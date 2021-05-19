import 'package:flutter_test/flutter_test.dart';
import 'package:history_app/auth/bloc/authentication_state.dart';

void main() {
  group('AuthenticationState', () {
    group('Uninitialized', () {
      test('supports value comparisons', () {
        expect(
          Uninitialized(),
          Uninitialized(),
        );
        expect(Uninitialized().toString(), Uninitialized().toString());
      });
    });
    group('Authenticated', () {
      final userId = 'user-id';
      test('supports value comparisons', () {
        expect(
          Authenticated(userId),
          Authenticated(userId),
        );
      });
    });

    group('LoginError', () {
      test('supports value comparisons', () {
        expect(
          LoginError(),
          LoginError(),
        );
      });
    });

    group('LoggingIn', () {
      test('supports value comparisons', () {
        expect(
          LoggingIn(),
          LoggingIn(),
        );
      });
    });
    group('LoggingOut', () {
      test('supports value comparisons', () {
        expect(
          LoggingOut(),
          LoggingOut(),
        );
      });
    });
    group('LogoutError', () {
      test('supports value comparisons', () {
        expect(
          LogoutError(),
          LogoutError(),
        );
      });
    });
  });
}
