import 'package:flutter_test/flutter_test.dart';
import 'package:history_app/blocs/auth/bloc/authentication_event.dart';

void main() {
  group('AuthenicationEvent', () {
    group('SignInAnonymously', () {
      test('supports value comparisons', () {
        expect(
          SignInAnonymously(),
          SignInAnonymously(),
        );
        expect(
          SignInAnonymously().toString(),
          SignInAnonymously().toString(),
        );
      });
    });
  });
}
