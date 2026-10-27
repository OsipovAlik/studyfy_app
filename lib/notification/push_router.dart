import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/router/app_router.dart';

/// What a push/local notification's `data.type` means.
enum PushTargetType {
  /// A teacher gave this student homework.
  homeworkAssigned,

  /// The teacher graded this student's task.
  homeworkGraded,

  /// A student handed in a task (sent to the teacher).
  homeworkSubmitted,

  /// A lesson starts in an hour (sent to the teacher and the students).
  sessionReminder,

  unknown
  ;

  static PushTargetType fromJson(String? value) => switch (value) {
    'homework_assigned' => PushTargetType.homeworkAssigned,
    'homework_graded' => PushTargetType.homeworkGraded,
    'homework_submitted' => PushTargetType.homeworkSubmitted,
    'session_reminder' => PushTargetType.sessionReminder,
    _ => PushTargetType.unknown,
  };
}

/// Where a tapped notification sends the user, from its `data` payload:
/// `{"type": "homework_assigned|homework_graded|homework_submitted",
/// "assignmentId": "..."}` opens that assignment, and
/// `{"type": "session_reminder", "sessionId": "..."}` opens the
/// Sessions tab — there's no single-session detail page to deep-link
/// into yet, so that's as specific as this gets for now.
abstract final class PushRouter {
  /// The in-app path for [data], or null if there's nowhere to go (an
  /// unknown type, or a homework payload missing its `assignmentId`).
  static String? pathFor(Map<String, dynamic> data) {
    return switch (PushTargetType.fromJson(data['type'] as String?)) {
      PushTargetType.homeworkAssigned ||
      PushTargetType.homeworkGraded ||
      PushTargetType.homeworkSubmitted => switch (data['assignmentId']) {
        final id? => '${AppRoutes.homework}/$id',
        _ => null,
      },
      PushTargetType.sessionReminder => AppRoutes.sessions,
      PushTargetType.unknown => null,
    };
  }

  /// Navigates to [data]'s target, e.g. an FCM `RemoteMessage.data`. A
  /// no-op if there's nowhere to go, or the app has no screen mounted
  /// yet to navigate from (a cold start mid-launch).
  static void handleData(Map<String, dynamic> data) {
    final path = pathFor(data);
    if (path == null) return;
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      debugPrint('PushRouter: no mounted navigator yet for "$path"');
      return;
    }
    unawaited(context.push(path));
  }

  /// Navigates to a local notification's JSON-encoded payload string
  /// (a notification's `payload` parameter).
  static void handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) handleData(decoded);
    } on FormatException catch (error) {
      debugPrint('PushRouter: malformed payload "$payload": $error');
    }
  }
}
