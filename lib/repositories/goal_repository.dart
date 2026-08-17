import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/goal.dart';

class GoalRepository {
  GoalRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _goals =>
      _firestore.collection('goals');

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    return user.uid;
  }

  Future<Goal> create(Goal goal) async {
    final userId = _requireUserId();
    final reference = goal.id.isEmpty ? _goals.doc() : _goals.doc(goal.id);
    final now = DateTime.now().toUtc();
    final created = Goal(
      id: reference.id,
      userId: userId,
      title: goal.title,
      description: goal.description,
      target: goal.target,
      currentValue: goal.currentValue,
      unit: goal.unit,
      deadline: goal.deadline,
      active: goal.active,
      createdAt: goal.createdAt ?? now,
      updatedAt: now,
    );

    await reference.set(created.toMap());
    return created;
  }

  Future<void> update(Goal goal) async {
    final userId = _requireUserId();
    await _goals
        .doc(goal.id)
        .set(
          Goal(
            id: goal.id,
            userId: userId,
            title: goal.title,
            description: goal.description,
            target: goal.target,
            currentValue: goal.currentValue,
            unit: goal.unit,
            deadline: goal.deadline,
            active: goal.active,
            createdAt: goal.createdAt,
            updatedAt: DateTime.now().toUtc(),
          ).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id) async {
    _requireUserId();
    await _goals.doc(id).delete();
  }

  Stream<List<Goal>> watchActiveGoals() {
    final userId = _requireUserId();
    return _goals
        .where('userId', isEqualTo: userId)
        .where('active', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Goal.fromMap(doc.data(), documentId: doc.id))
              .toList(growable: false),
        );
  }
}
