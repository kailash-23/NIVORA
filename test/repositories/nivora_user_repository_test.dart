import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/models/nivora_user_profile.dart';

void main() {
  test('user profile map round-trips', () {
    final profile = NivoraUserProfile(
      uid: 'user-1',
      displayName: 'User',
      email: 'user@example.com',
      photoUrl: null,
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 17),
    );

    final decoded = NivoraUserProfile.fromMap(profile.toMap());

    expect(decoded.uid, 'user-1');
    expect(decoded.email, 'user@example.com');
  });
}
