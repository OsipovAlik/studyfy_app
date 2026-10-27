import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/results_list_controller.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/features/students/students_controller.dart';
import 'package:studify/features/students/widgets/delete_student_dialog.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One student: their contact info, Delete, and the tests they've taken.
/// Teacher-only — the Students list only pushes this route for a
/// teacher.
class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({required this.studentId, super.key});

  final int studentId;

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<StudentsController>().ensureLoaded());
    unawaited(context.read<ResultsListController>().ensureLoaded());
  }

  Future<void> _refresh() => Future.wait([
    context.read<StudentsController>().reload(),
    context.read<ResultsListController>().reload(),
  ]);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final studentsController = context.watch<StudentsController>();
    final resultsController = context.watch<ResultsListController>();
    final student = studentsController.students
        .where((s) => s.id == widget.studentId)
        .firstOrNull;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: student == null
                ? (studentsController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _NotFound(message: l10n.studentsNotFoundDescription))
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const _BackRow(),
                        const SizedBox(height: 16),
                        _HeroCard(student: student),
                        const SizedBox(height: 16),
                        _InfoCard(
                          student: student,
                          controller: studentsController,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.studentsTestResultsTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _ResultsSection(
                          studentId: student.id,
                          controller: resultsController,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BackRow(),
          const SizedBox(height: 40),
          Text(
            l10n.studentsNotFoundTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _BackRow extends StatelessWidget {
  const _BackRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.back, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              l10n.studentsBackToStudents,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

String _initialsOf(Student student) => [student.name, student.surname]
    .where((part) => part.isNotEmpty)
    .map((part) => part.characters.first.toUpperCase())
    .join();

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initialsOf(student);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Text(
              initials.isEmpty ? '?' : initials,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            student.fullName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            student.email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.student, required this.controller});

  final Student student;
  final StudentsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final created = student.createdAt;
    final registeredLabel = created == null
        ? null
        : DateFormat.yMMMMd(locale).format(created.toLocal());

    Widget row(IconData icon, String label, String value) => Row(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(
            CupertinoIcons.mail_solid,
            l10n.studentsEmailLabel,
            student.email,
          ),
          if (registeredLabel != null) ...[
            const SizedBox(height: 14),
            row(
              CupertinoIcons.calendar,
              l10n.studentsRegisteredLabel,
              registeredLabel,
            ),
          ],
          const SizedBox(height: 14),
          Divider(height: 1, color: scheme.outlineVariant),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => unawaited(
                  showDeleteStudentDialog(
                    context,
                    student: student,
                    controller: controller,
                  ).then((_) {
                    // The dialog pops itself on success; if the student
                    // is now gone from the roster, this page has
                    // nothing left to show.
                    if (!context.mounted) return;
                    final stillThere = controller.students.any(
                      (s) => s.id == student.id,
                    );
                    if (!stillThere) context.pop();
                  }),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.trash, size: 15, color: scheme.error),
                      const SizedBox(width: 6),
                      Text(
                        l10n.studentsDelete,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({required this.studentId, required this.controller});

  final int studentId;
  final ResultsListController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (controller.isLoading && controller.results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.hasError) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              l10n.resultsLoadError,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => unawaited(controller.reload()),
              child: Text(l10n.callTryAgain),
            ),
          ],
        ),
      );
    }

    final results = controller.results
        .where((r) => r.studentId == studentId)
        .toList();

    if (results.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Text(
          l10n.studentsResultsEmptyHint,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            _ResultRow(result: results[i], controller: controller),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.controller});

  final Result result;
  final ResultsListController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final percent = result.percentage.round();
    final color = percent >= 70
        ? AppColors.emerald500
        : percent >= 40
        ? AppColors.amber500
        : AppColors.red500;
    final created = result.createdAt;
    final dateLabel = created == null
        ? ''
        : DateFormat.yMMMd(locale).format(created.toLocal());

    return ListTile(
      onTap: () => context.push('${AppRoutes.results}/${result.id}'),
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          shape: BoxShape.circle,
        ),
        child: Text(
          '$percent%',
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        controller.testTitle(result.testId, l10n),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        [
          '${result.score} / ${result.total}',
          if (dateLabel.isNotEmpty) dateLabel,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
