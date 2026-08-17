import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event.dart';
import '../services/nivora_date_service.dart';

class EventRepository {
  EventRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    NivoraDateService? dateService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _dateService = dateService ?? const NivoraDateService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NivoraDateService _dateService;

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection('events');

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    return user.uid;
  }

  Future<NivoraEvent> create(NivoraEvent event) async {
    final userId = _requireUserId();
    final reference = event.id.isEmpty ? _events.doc() : _events.doc(event.id);
    final now = DateTime.now().toUtc();
    final created = NivoraEvent(
      id: reference.id,
      userId: userId,
      title: event.title,
      description: event.description,
      startAt: event.startAt,
      endAt: event.endAt,
      completed: event.completed,
      createdAt: event.createdAt ?? now,
      updatedAt: now,
    );

    await reference.set(created.toMap());
    return created;
  }

  Future<void> update(NivoraEvent event) async {
    final userId = _requireUserId();
    await _events
        .doc(event.id)
        .set(
          NivoraEvent(
            id: event.id,
            userId: userId,
            title: event.title,
            description: event.description,
            startAt: event.startAt,
            endAt: event.endAt,
            completed: event.completed,
            createdAt: event.createdAt,
            updatedAt: DateTime.now().toUtc(),
          ).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id) async {
    _requireUserId();
    await _events.doc(id).delete();
  }

  Stream<List<NivoraEvent>> watchUpcomingEvents({DateTime? from}) {
    final userId = _requireUserId();
    final start = from ?? _dateService.today();
    return _events
        .where('userId', isEqualTo: userId)
        .where('startAt', isGreaterThanOrEqualTo: start)
        .orderBy('startAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NivoraEvent.fromMap(doc.data(), documentId: doc.id))
              .toList(growable: false),
        );
  }
}
