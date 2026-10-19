import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/features/students/students_controller.dart';
import 'package:studify/features/students/widgets/add_student_sheet.dart';
import 'package:studify/features/students/widgets/delete_student_dialog.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The Students tab (teachers only): the school's student roster.
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<StudentsController>().ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = context.watch<StudentsController>();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Text(
                    l10n.studentsTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.studentsSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  PickerPill<int?>(
                    value: controller.subjectFilter,
                    label: controller.subjects.where((s) => s.id == controller.subjectFilter).firstOrNull?.name ?? l10n.studentsFilterAll,
                    options: [
                      (value: null, label: l10n.studentsFilterAll),
                      for (final subject in controller.subjects) (value: subject.id, label: subject.name),
                    ],
                    onChanged: (id) => unawaited(controller.setSubjectFilter(id)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => unawaited(
                        showAddStudentSheet(context, controller: controller),
                      ),
                      icon: const Icon(CupertinoIcons.add, size: 18),
                      label: Text(l10n.studentsAddStudent),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (controller.isLoading && controller.students.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.hasError)
                    _ErrorState(
                      message: l10n.studentsLoadError,
                      onRetry: controller.reload,
                    )
                  else if (controller.students.isEmpty)
                    _EmptyState(
                      title: l10n.studentsEmptyTitle,
                      description: l10n.studentsEmptyDescription,
                    )
                  else
                    _StudentList(
                      students: controller.students,
                      controller: controller,
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

class _StudentList extends StatelessWidget {
  const _StudentList({required this.students, required this.controller});

  final List<Student> students;
  final StudentsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < students.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            _StudentRow(student: students[i], controller: controller),
          ],
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student, required this.controller});

  final Student student;
  final StudentsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListTile(
      onTap: () => context.push('/students/${student.id}'),
      leading: _Avatar(student: student),
      title: Text(student.fullName, style: theme.textTheme.titleSmall),
      subtitle: Text(student.email),
      trailing: IconButton(
        tooltip: l10n.studentsDelete,
        onPressed: () => unawaited(
          showDeleteStudentDialog(
            context,
            student: student,
            controller: controller,
          ),
        ),
        icon: Icon(CupertinoIcons.trash, color: scheme.error, size: 20),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final initials = [
      student.name,
      student.surname,
    ].where((part) => part.isNotEmpty).map((part) => part.characters.first.toUpperCase()).join();
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person_3_fill,
              size: 36,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          if (description case final text?) ...[
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text(l10n.callTryAgain)),
        ],
      ),
    );
  }
}
