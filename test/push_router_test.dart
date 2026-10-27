import 'package:flutter_test/flutter_test.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/notification/push_router.dart';

void main() {
  group('PushRouter.pathFor', () {
    test('homework_assigned opens the assignment', () {
      expect(
        PushRouter.pathFor({'type': 'homework_assigned', 'assignmentId': '42'}),
        '${AppRoutes.homework}/42',
      );
    });

    test('homework_graded opens the assignment', () {
      expect(
        PushRouter.pathFor({'type': 'homework_graded', 'assignmentId': '42'}),
        '${AppRoutes.homework}/42',
      );
    });

    test('homework_submitted opens the assignment', () {
      expect(
        PushRouter.pathFor({'type': 'homework_submitted', 'assignmentId': '7'}),
        '${AppRoutes.homework}/7',
      );
    });

    test('session_reminder opens the Sessions tab', () {
      expect(
        PushRouter.pathFor({'type': 'session_reminder', 'sessionId': '7'}),
        AppRoutes.sessions,
      );
    });

    test('a homework payload missing its assignmentId goes nowhere', () {
      expect(PushRouter.pathFor({'type': 'homework_assigned'}), isNull);
    });

    test('an unknown type goes nowhere', () {
      expect(
        PushRouter.pathFor({'type': 'something_else', 'assignmentId': '1'}),
        isNull,
      );
    });

    test('a missing type goes nowhere', () {
      expect(PushRouter.pathFor({'assignmentId': '1'}), isNull);
    });
  });

  group('PushRouter.handlePayload', () {
    test('a malformed payload is ignored, not thrown', () {
      // No navigator mounted in this test either way; this only checks
      // that decoding garbage doesn't throw.
      expect(() => PushRouter.handlePayload('not json'), returnsNormally);
      expect(() => PushRouter.handlePayload(''), returnsNormally);
      expect(() => PushRouter.handlePayload(null), returnsNormally);
    });
  });
}
