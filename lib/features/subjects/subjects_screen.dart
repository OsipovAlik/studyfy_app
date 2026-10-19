import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/subjects/domain/subject.dart';
import 'package:studify/features/subjects/subjects_controller.dart';
import 'package:studify/features/subjects/widgets/subject_form_sheet.dart';
import 'package:studify/features/subjects/widgets/subject_row.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The Subjects tab: the school's subjects. Any role can see the list;
/// only a teacher can add, rename, activate/deactivate or delete one.
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<SubjectsController>().ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = context.watch<SubjectsController>();
    final subjects = controller.subjects;

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
                    l10n.subjectsTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.subjectsSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (controller.isTeacher) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => unawaited(
                          showSubjectFormSheet(context, controller: controller),
                        ),
                        icon: const Icon(CupertinoIcons.add, size: 18),
                        label: Text(l10n.subjectsAddSubject),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  if (controller.isLoading && subjects.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.hasError)
                    _ErrorState(
                      message: l10n.subjectsLoadError,
                      onRetry: controller.reload,
                    )
                  else if (subjects.isEmpty)
                    _EmptyState(
                      title: l10n.subjectsEmptyTitle,
                      description: controller.isTeacher
                          ? l10n.subjectsEmptyDescription
                          : null,
                    )
                  else
                    _SubjectList(subjects: subjects, controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectList extends StatelessWidget {
  const _SubjectList({required this.subjects, required this.controller});

  final List<Subject> subjects;
  final SubjectsController controller;

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
          for (var i = 0; i < subjects.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            SubjectRow(subject: subjects[i], controller: controller),
          ],
        ],
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
            child: Icon(CupertinoIcons.book, size: 36, color: scheme.primary),
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
