import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/firestore_value_utils.dart';
import '../models/nivora_user_profile.dart';

class NivoraUserRepository {
  NivoraUserRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<NivoraUserProfile> ensureCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    final now = DateTime.now().toUtc();
    final fallbackProfile = NivoraUserProfile(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final reference = _users.doc(user.uid);
      final snapshot = await reference.get();

      if (!snapshot.exists) {
        await reference.set(fallbackProfile.toMap());
        return fallbackProfile;
      }

      final existing = NivoraUserProfile.fromMap(
        snapshot.data() ?? <String, dynamic>{},
      );
      if (existing.uid.isEmpty) {
        final profile = NivoraUserProfile(
          uid: user.uid,
          displayName: existing.displayName ?? user.displayName,
          email: existing.email ?? user.email,
          photoUrl: existing.photoUrl ?? user.photoURL,
          createdAt: existing.createdAt ?? now,
          updatedAt: now,
        );

        await reference.set(profile.toMap(), SetOptions(merge: true));
        return profile;
      }

      return existing;
    } catch (_) {
      return fallbackProfile;
    }
  }

  Future<NivoraUserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final snapshot = await _users.doc(user.uid).get();
      if (snapshot.exists) {
        final profile = NivoraUserProfile.fromMap(
          snapshot.data() ?? <String, dynamic>{},
        );
        if (profile.uid.isNotEmpty) {
          return profile;
        }
      }
    } catch (_) {
      // Fallback cleanly to FirebaseAuth details if offline or permission denied
    }

    return NivoraUserProfile(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Future<void> updateCurrentUserProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    await _users.doc(user.uid).set(<String, dynamic>{
      'uid': user.uid,
      'displayName': ?displayName,
      'email': ?email,
      'photoUrl': ?photoUrl,
      'updatedAt': firestoreTimestampFromDateTime(DateTime.now().toUtc()),
    }, SetOptions(merge: true));
  }
}
