import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileX.isProfileComplete', () {
    test('nameless profile with only a phone is incomplete', () {
      const profile = UserProfile(phone: '9999999999');
      expect(profile.isProfileComplete, isFalse);
    });

    test('nameless profile with only an email is incomplete', () {
      const profile = UserProfile(email: 'asha@example.com');
      expect(profile.isProfileComplete, isFalse);
    });

    test('profile with full_name is complete', () {
      const profile = UserProfile(
        fullName: 'Asha Sharma',
        phone: '9999999999',
      );
      expect(profile.isProfileComplete, isTrue);
    });

    test('profile with first/last name is complete', () {
      const profile = UserProfile(firstName: 'Asha', lastName: 'Sharma');
      expect(profile.isProfileComplete, isTrue);
    });

    test('blank names are incomplete', () {
      const profile = UserProfile(fullName: '   ', phone: '9999999999');
      expect(profile.isProfileComplete, isFalse);
    });
  });
}
