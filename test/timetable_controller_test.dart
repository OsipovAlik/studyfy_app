import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

import 'support/fakes.dart';

const Map<String, Object?> _studentJson = {
  'id': 4,
  'name': 'John',
  'surname': 'Doe',
  'email': 'john@example.com',
  'role': 'student',
  'partnerId': 1,
  'partnerName': 'Acme Language School',
};

void main() {
  late FakeApi api;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    api = FakeApi()
      // [TimetableController] always loads the group list now (it backs
      // the Groups tab for every role); tests override it when they
      // care about its contents.
      ..on('GET /group/list', [
        const FakeResponse(200, {'groups': <Object?>[]}),
      ]);
  });

  AuthController authWith(Map<String, Object?> userJson) {
    final client = fakeClient(api);
    return AuthController(
      client: client,
      repository: AuthRepository(client),
      storage: MemorySessionStorage(),
      restored: StoredSession(
        token: 'tok',
        user: UserProfile.fromJson(userJson),
      ),
    );
  }

  TimetableController controllerFor(
    Map<String, Object?> userJson, {
    List<Object?> sessions = const [],
  }) {
    api
      ..on('GET /session/my', [
        FakeResponse(200, {'sessions': sessions}),
      ])
      ..on('GET /session/list', [
        FakeResponse(200, {'sessions': sessions}),
      ]);
    return TimetableController(
      repository: SessionsRepository(fakeClient(api)),
      auth: authWith(userJson),
    );
  }

  Map<String, Object?> sessionJson({
    required int id,
    required String type,
    required String day,
    required String time,
    int? groupId,
    int? studentId,
  }) => {
    'ID': id,
    'type': type,
    'dayOfWeek': day,
    'startTime': time,
    'groupId': groupId,
    'studentId': studentId,
  };

  group('onDay', () {
    test('groups by weekday and sorts by start time', () async {
      final controller = controllerFor(
        _studentJson,
        sessions: [
          sessionJson(id: 1, type: 'individual', day: 'monday', time: '15:00'),
          sessionJson(
            id: 2,
            type: 'group',
            day: 'monday',
            time: '09:00',
            groupId: 1,
          ),
          sessionJson(
            id: 3,
            type: 'group',
            day: 'tuesday',
            time: '10:00',
            groupId: 1,
          ),
        ],
      );
      await controller.ensureLoaded();

      final monday = controller.onDay(Weekday.monday);
      expect(monday.map((s) => s.id), [2, 1]);
      expect(controller.onDay(Weekday.tuesday).single.id, 3);
      expect(controller.onDay(Weekday.sunday), isEmpty);
    });
  });

  group('next', () {
    test('is null when there are no sessions', () async {
      final controller = controllerFor(_studentJson);
      await controller.ensureLoaded();
      expect(controller.next, isNull);
    });

    test('picks a later session today over one that already ended', () async {
      final controller = controllerFor(
        _studentJson,
        sessions: [
          sessionJson(
            id: 1,
            type: 'individual',
            day: 'thursday',
            time: '08:00',
          ),
          sessionJson(
            id: 2,
            type: 'individual',
            day: 'thursday',
            time: '15:00',
          ),
        ],
      );
      await controller.ensureLoaded();

      // Thursday 2026-10-15, 09:00: the 08:00 class is over, 15:00 is next.
      await withClock(Clock.fixed(DateTime(2026, 10, 15, 9)), () async {
        final next = controller.next;
        expect(next?.session.id, 2);
        expect(next?.isHappeningNow, isFalse);
        expect(next?.date, DateTime(2026, 10, 15));
      });
    });

    test('treats a session from the last hour as happening now', () async {
      final controller = controllerFor(
        _studentJson,
        sessions: [
          sessionJson(
            id: 1,
            type: 'individual',
            day: 'thursday',
            time: '08:40',
          ),
        ],
      );
      await controller.ensureLoaded();

      await withClock(Clock.fixed(DateTime(2026, 10, 15, 9, 10)), () async {
        final next = controller.next;
        expect(next?.session.id, 1);
        expect(next?.isHappeningNow, isTrue);
      });
    });

    test(
      "a session over an hour ago today is skipped for tomorrow's",
      () async {
        final controller = controllerFor(
          _studentJson,
          sessions: [
            sessionJson(
              id: 1,
              type: 'individual',
              day: 'thursday',
              time: '08:00',
            ),
            sessionJson(
              id: 2,
              type: 'individual',
              day: 'friday',
              time: '09:00',
            ),
          ],
        );
        await controller.ensureLoaded();

        await withClock(Clock.fixed(DateTime(2026, 10, 15, 9, 30)), () async {
          final next = controller.next;
          expect(next?.session.id, 2);
          expect(next?.date, DateTime(2026, 10, 16));
        });
      },
    );

    test('wraps around to next week when nothing is left this week', () async {
      final controller = controllerFor(
        _studentJson,
        sessions: [
          sessionJson(id: 1, type: 'individual', day: 'monday', time: '09:00'),
        ],
      );
      await controller.ensureLoaded();

      // Thursday: Monday's class already happened this week.
      await withClock(Clock.fixed(DateTime(2026, 10, 15, 12)), () async {
        final next = controller.next;
        expect(next?.session.id, 1);
        expect(next?.date, DateTime(2026, 10, 19));
      });
    });
  });

  group('label', () {
    test('a student sees just the type, even with a known id', () async {
      final controller = controllerFor(
        _studentJson,
        sessions: [
          sessionJson(
            id: 1,
            type: 'group',
            day: 'monday',
            time: '09:00',
            groupId: 7,
          ),
        ],
      );
      await controller.ensureLoaded();
      final session = controller.onDay(Weekday.monday).single;
      expect(controller.label(session, l10n), 'Group');
    });

    test('a teacher sees the resolved group and student names', () async {
      api
        ..on('GET /group/list', [
          const FakeResponse(200, {
            'groups': [
              {'ID': 7, 'name': 'Beginners A1'},
            ],
          }),
        ])
        ..on('GET /students', [
          const FakeResponse(200, {
            'users': [
              {
                'ID': 4,
                'name': 'Anna',
                'surname': 'K.',
                'email': 'a@b.c',
                'role': 'student',
              },
            ],
          }),
        ]);
      final controller = controllerFor(
        teacherJson,
        sessions: [
          sessionJson(
            id: 1,
            type: 'group',
            day: 'monday',
            time: '09:00',
            groupId: 7,
          ),
          sessionJson(
            id: 2,
            type: 'individual',
            day: 'monday',
            time: '10:00',
            studentId: 4,
          ),
          sessionJson(
            id: 3,
            type: 'group',
            day: 'monday',
            time: '11:00',
            groupId: 99,
          ),
        ],
      );
      await controller.ensureLoaded();

      final sessions = controller.onDay(Weekday.monday);
      expect(controller.label(sessions[0], l10n), 'Beginners A1');
      expect(controller.label(sessions[1], l10n), 'Anna K.');
      // An id with no matching name falls back to a numbered label.
      expect(controller.label(sessions[2], l10n), 'Group #99');
    });
  });

  group('loading', () {
    test('hasError is set on a failed load, and reload clears it', () async {
      final client = fakeClient(api);
      final controller = TimetableController(
        repository: SessionsRepository(client),
        auth: authWith(_studentJson),
      );

      api.on('GET /session/my', [const FakeResponse(500)]);
      await controller.ensureLoaded();
      expect(controller.hasError, isTrue);
      expect(controller.sessions, isEmpty);

      api.on('GET /session/my', [
        FakeResponse(200, {
          'sessions': [
            sessionJson(
              id: 1,
              type: 'individual',
              day: 'monday',
              time: '09:00',
            ),
          ],
        }),
      ]);
      await controller.reload();
      expect(controller.hasError, isFalse);
      expect(controller.sessions, hasLength(1));
    });
  });
}
