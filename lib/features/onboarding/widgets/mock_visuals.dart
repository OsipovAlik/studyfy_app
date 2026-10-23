import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/onboarding/widgets/onboarding_slide.dart';
import 'package:studify/l10n/app_localizations.dart';

/// A test question with the correct answer marked, and the result card
/// overlapping it — the website's "test result" mockup.
class TestResultMock extends StatelessWidget {
  const TestResultMock({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      height: 300,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 28, child: _QuestionCard()),
          Positioned(right: 0, bottom: 0, child: _ResultCard()),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MockCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconTile(
                icon: CupertinoIcons.photo,
                color: scheme.primary,
                background: scheme.primaryContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.landingMockQuestion,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _AnswerOption(label: 'A', text: 'pomme', correct: true),
          const SizedBox(height: 8),
          const _AnswerOption(label: 'B', text: 'poire'),
          const SizedBox(height: 8),
          const _AnswerOption(label: 'C', text: 'banane'),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.text,
    this.correct = false,
  });

  final String label;
  final String text;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = correct ? AppColors.emerald500 : scheme.outline;

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: correct
            ? AppColors.emerald500.withValues(alpha: 0.1)
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: accent, width: correct ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: correct ? AppColors.emerald500 : scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: correct ? Colors.white : scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          if (correct)
            const Icon(
              CupertinoIcons.checkmark_circle_fill,
              color: AppColors.emerald500,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Transform.rotate(
      angle: 0.04,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: MockCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 7 / 8),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => SizedBox.square(
                  dimension: 56,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        color: AppColors.emerald500,
                        backgroundColor: AppColors.emerald500.withValues(
                          alpha: 0.15,
                        ),
                      ),
                      Center(
                        child: Text(
                          '87%',
                          style: theme.textTheme.labelLarge?.weight(
                            FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.landingMockResult, style: muted),
                    Text(
                      '7 / 8',
                      style: theme.textTheme.titleLarge?.weight(
                        FontWeight.w700,
                      ),
                    ),
                    Text(l10n.landingMockCorrect, style: muted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This week's timetable with today's classes — the website's
/// timetable mockup, plus a "join video class" button.
class TimetableMock extends StatelessWidget {
  const TimetableMock({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: 320,
      child: MockCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _IconTile(
                  icon: CupertinoIcons.calendar,
                  color: scheme.primary,
                  background: scheme.primaryContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.landingMockTimetable,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.landingMockToday,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _WeekStrip(),
            const SizedBox(height: 16),
            _SessionTile(
              time: '09:00',
              title: 'Beginners',
              tag: l10n.landingMockGroup,
              icon: CupertinoIcons.person_3_fill,
              color: AppColors.indigo500,
              live: true,
            ),
            const SizedBox(height: 10),
            _SessionTile(
              time: '18:30',
              title: 'Anna K.',
              tag: l10n.landingMockIndividual,
              icon: CupertinoIcons.person_fill,
              color: AppColors.emerald500,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final today = DateUtils.dateOnly(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final dayName = DateFormat.E(localeTag);

    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Builder(
              builder: (context) {
                final day = monday.add(Duration(days: i));
                final isToday = day == today;
                return Column(
                  children: [
                    Text(
                      dayName.format(day),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isToday ? scheme.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isToday ? scheme.onPrimary : scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.time,
    required this.title,
    required this.tag,
    required this.icon,
    required this.color,
    this.live = false,
  });

  final String time;
  final String title;
  final String tag;
  final IconData icon;
  final Color color;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: BorderDirectional(start: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Text(
            time,
            style: theme.textTheme.titleSmall?.weight(FontWeight.w700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(icon, size: 14, color: color),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        tag,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (live)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(
                CupertinoIcons.videocam_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

/// "For teachers" / "For students" cards.
class RolesMock extends StatelessWidget {
  const RolesMock({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 340,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleCard(
            icon: CupertinoIcons.person_crop_rectangle_fill,
            color: AppColors.indigo500,
            title: l10n.landingTeachersTitle,
            points: [
              l10n.landingTeachersPoint1,
              l10n.landingTeachersPoint2,
              l10n.landingTeachersPoint3,
              l10n.landingTeachersPoint4,
            ],
          ),
          const SizedBox(height: 12),
          _RoleCard(
            icon: CupertinoIcons.pencil,
            color: AppColors.emerald500,
            title: l10n.landingStudentsTitle,
            points: [
              l10n.landingStudentsPoint1,
              l10n.landingStudentsPoint2,
              l10n.landingStudentsPoint3,
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.points,
  });

  final IconData icon;
  final Color color;
  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MockCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconTile(
                icon: icon,
                color: Colors.white,
                background: color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final point in points)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.checkmark_alt, size: 18, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(point, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Icon(icon, size: 19, color: color),
    );
  }
}
