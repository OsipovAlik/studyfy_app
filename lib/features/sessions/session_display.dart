import 'package:flutter/material.dart' show Color;
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The translated weekday name, as the website shows it.
extension WeekdayLabel on Weekday {
  String label(AppLocalizations l10n) => switch (this) {
    Weekday.monday => l10n.weekdayMonday,
    Weekday.tuesday => l10n.weekdayTuesday,
    Weekday.wednesday => l10n.weekdayWednesday,
    Weekday.thursday => l10n.weekdayThursday,
    Weekday.friday => l10n.weekdayFriday,
    Weekday.saturday => l10n.weekdaySaturday,
    Weekday.sunday => l10n.weekdaySunday,
  };
}

/// Morning, afternoon or evening, for the coloured dot next to a class
/// time (before 12:00, 12:00–17:00, from 17:00 — as on the website).
enum SessionTimeRange {
  morning,
  afternoon,
  evening
  ;

  factory SessionTimeRange.of(int startMinutes) {
    if (startMinutes < 12 * 60) return SessionTimeRange.morning;
    if (startMinutes < 17 * 60) return SessionTimeRange.afternoon;
    return SessionTimeRange.evening;
  }

  String label(AppLocalizations l10n) => switch (this) {
    SessionTimeRange.morning => l10n.sessionMorning,
    SessionTimeRange.afternoon => l10n.sessionAfternoon,
    SessionTimeRange.evening => l10n.sessionEvening,
  };

  Color get color => switch (this) {
    SessionTimeRange.morning => AppColors.amber500,
    SessionTimeRange.afternoon => AppColors.emerald500,
    SessionTimeRange.evening => AppColors.indigo500,
  };
}

extension SessionTimeRangeOf on ClassSession {
  SessionTimeRange get timeRange => SessionTimeRange.of(startMinutes);
}

/// "Group" or "Individual", regardless of whether a name was resolved.
extension SessionTypeLabel on SessionType {
  String label(AppLocalizations l10n) => switch (this) {
    SessionType.group => l10n.sessionTypeGroup,
    SessionType.individual || SessionType.unknown => l10n.sessionTypeIndividual,
  };
}
