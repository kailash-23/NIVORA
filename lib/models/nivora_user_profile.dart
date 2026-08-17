import '../data/firestore_value_utils.dart';

class NivoraUserProfile {
  const NivoraUserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': firestoreTimestampFromDateTime(createdAt),
      'updatedAt': firestoreTimestampFromDateTime(updatedAt),
    };
  }

  factory NivoraUserProfile.fromMap(Map<String, dynamic> map) {
    return NivoraUserProfile(
      uid: stringFromFirestoreValue(map['uid']) ?? '',
      displayName: stringFromFirestoreValue(map['displayName']),
      email: stringFromFirestoreValue(map['email']),
      photoUrl: stringFromFirestoreValue(map['photoUrl']),
      createdAt: dateTimeFromFirestoreValue(map['createdAt']),
      updatedAt: dateTimeFromFirestoreValue(map['updatedAt']),
    );
  }
}
