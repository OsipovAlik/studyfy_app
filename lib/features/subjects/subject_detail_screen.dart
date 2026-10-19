import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/subjects/data/levels_repository.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/domain/level.dart';
import 'package:studify/features/subjects/domain/subject.dart';
import 'package:studify/features/subjects/domain/test.dart';
import 'package:studify/features/subjects/subject_detail_controller.dart';
import 'package:studify/features/subjects/subjects_controller.dart';
import 'package:studify/features/subjects/widgets/generate_test_sheet.dart';
import 'package:studify/features/subjects/widgets/level_form_sheet.dart';
import 'package:studify/features/subjects/widgets/subject_form_sheet.dart';
import 'package:studify/features/subjects/widgets/test_form_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

enum _Tab { tests, levels }

/// One subject: its own active/rename controls (shared with the
/// Subjects list, via [SubjectsController]), then its levels and the
/// tests of whichever level is selected. Teacher-only — the Subjects
/// list only pushes this route for a teacher.
class SubjectDetailScreen extends StatefulWidget {
  const SubjectDetailScreen({required this.subjectId, super.key});

  final int subjectId;

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  late final SubjectDetailController _controller;
  _Tab _tab = _Tab.tests;

  @override
  void initState() {
    super.initState();
    _controller = SubjectDetailController(
      subjectId: widget.subjectId,
      levels: context.read<LevelsRepository>(),
      tests: context.read<TestsRepository>(),
    )..addListener(_handleChange);
    unawaited(context.read<SubjectsController>().ensureLoaded());
    unawaited(_controller.loadLevels());
  }

  void _handleChange() {
    if (mounted) setState(() {});
  }

  Future<void> _refresh() => Future.wait([
    context.read<SubjectsController>().reload(),
    _controller.loadLevels(),
  ]);

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subjectsController = context.watch<SubjectsController>();
    final subject = subjectsController.subjects
        .where((s) => s.id == widget.subjectId)
        .firstOrNull;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: subject == null
                ? (subjectsController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _NotFound(
                          message: l10n.subjectDetailNotFoundDescription,
                        ))
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const _BackRow(),
                        const SizedBox(height: 16),
                        _HeroCard(subject: subject),
                        const SizedBox(height: 16),
                        _InfoCard(
                          subject: subject,
                          controller: subjectsController,
                        ),
                        const SizedBox(height: 20),
                        _SegmentedTabs(
                          tab: _tab,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 16),
                        if (_tab == _Tab.tests)
                          _TestsTab(controller: _controller)
                        else
                          _LevelsTab(controller: _controller),
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
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BackRow(),
          const SizedBox(height: 40),
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
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.back, size: 22, color: scheme.onSurfaceVariant),
            // const SizedBox(width: 6),
            // Text(
            //   l10n.subjectDetailBackToSubjects,
            //   style: Theme.of(
            //     context,
            //   ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            // ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              CupertinoIcons.book_fill,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subject.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: subject.isActive
                        ? AppColors.emerald400
                        : Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  subject.isActive
                      ? l10n.subjectsActiveLabel
                      : l10n.subjectsInactiveLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.subject, required this.controller});

  final Subject subject;
  final SubjectsController controller;

  Future<void> _toggleActive(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await controller.toggleActive(subject.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectsActivateError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final created = subject.createdAt;
    final dateLabel = created == null
        ? null
        : DateFormat.yMMMMd(locale).format(created.toLocal());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dateLabel != null) ...[
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.calendar,
                    size: 18,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subjectDetailCreatedLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(dateLabel, style: theme.textTheme.titleSmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: scheme.outlineVariant),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              _ActionChip(
                key: const ValueKey('subject-detail-toggle-active'),
                icon: CupertinoIcons.bolt_fill,
                label: subject.isActive
                    ? l10n.subjectsDeactivate
                    : l10n.subjectsActivate,
                color: AppColors.amber500,
                onTap: () => unawaited(_toggleActive(context)),
              ),
              const SizedBox(width: 20),
              _ActionChip(
                key: const ValueKey('subject-detail-rename'),
                icon: CupertinoIcons.pencil,
                label: l10n.subjectsRename,
                color: scheme.onSurface,
                onTap: () => unawaited(
                  showSubjectFormSheet(
                    context,
                    controller: controller,
                    editing: subject,
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

/// A small icon+label tap target used for inline row actions (Deactivate/
/// Activate, Rename, Edit, Delete) throughout this screen.
class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.tab, required this.onChanged});

  final _Tab tab;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget segment({
      required _Tab value,
      required IconData icon,
      required String label,
    }) {
      final selected = tab == value;
      return Expanded(
        child: Material(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: selected
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          segment(
            value: _Tab.tests,
            icon: CupertinoIcons.doc_text_fill,
            label: l10n.subjectDetailTabTests,
          ),
          segment(
            value: _Tab.levels,
            icon: CupertinoIcons.square_stack_3d_up_fill,
            label: l10n.subjectDetailTabLevels,
          ),
        ],
      ),
    );
  }
}

class _TestsTab extends StatelessWidget {
  const _TestsTab({required this.controller});

  final SubjectDetailController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (controller.isLoadingLevels && controller.levels.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.hasLevelsError) {
      return _ErrorState(
        message: l10n.subjectDetailLevelsLoadError,
        onRetry: () => unawaited(controller.loadLevels()),
      );
    }
    if (controller.levels.isEmpty) {
      return _EmptyState(
        icon: CupertinoIcons.square_stack_3d_up,
        title: l10n.subjectDetailNoLevelsHint,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.levels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final level = controller.levels[index];
              final selected = level.id == controller.selectedLevelId;
              return _LevelChip(
                level: level,
                selected: selected,
                onTap: () => unawaited(controller.selectLevel(level.id)),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => unawaited(
                  showGenerateTestSheet(context, controller: controller).then((
                    result,
                  ) {
                    if (result == null || !context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.subjectDetailGenerateSuccess(
                            result.generated,
                            result.requested,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                icon: const Icon(CupertinoIcons.sparkles, size: 16),
                label: Text(l10n.subjectDetailGenerateWithAi),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => unawaited(
                  showTestFormSheet(context, controller: controller),
                ),
                icon: const Icon(CupertinoIcons.add, size: 16),
                label: Text(l10n.subjectDetailAddTest),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (controller.isLoadingTests && controller.tests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (controller.hasTestsError)
          _ErrorState(
            message: l10n.subjectDetailTestsLoadError,
            onRetry: () => unawaited(controller.reloadTests()),
          )
        else if (controller.tests.isEmpty)
          _EmptyState(
            icon: CupertinoIcons.doc_text,
            title: l10n.subjectDetailTestsEmptyTitle,
            description: l10n.subjectDetailTestsEmptyDescription,
          )
        else
          Column(
            children: [
              for (final test in controller.tests)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TestCard(test: test, controller: controller),
                ),
            ],
          ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final Level level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primary
          : scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: selected ? null : Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.square_stack_3d_up_fill,
                size: 13,
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                level.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test, required this.controller});

  final Test test;
  final SubjectDetailController controller;

  Future<void> _toggleActive(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await controller.updateTest(test.id, isActive: !test.isActive);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectDetailTestUpdateError,
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.subjectDetailDeleteTestConfirmTitle(test.title)),
        content: Text(l10n.subjectDetailDeleteTestConfirmDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.subjectsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteTest(test.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectDetailTestDeleteError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final statusColor = test.isActive
        ? AppColors.emerald500
        : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  CupertinoIcons.doc_text_fill,
                  size: 16,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(test.title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          test.isActive
                              ? l10n.subjectsActiveLabel
                              : l10n.subjectsInactiveLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: scheme.outlineVariant),
          const SizedBox(height: 10),
          Row(
            children: [
              _ActionChip(
                key: ValueKey('test-toggle-active-${test.id}'),
                icon: CupertinoIcons.bolt_fill,
                label: test.isActive
                    ? l10n.subjectsDeactivate
                    : l10n.subjectsActivate,
                color: AppColors.amber500,
                onTap: () => unawaited(_toggleActive(context)),
              ),
              const SizedBox(width: 16),
              _ActionChip(
                key: ValueKey('test-edit-${test.id}'),
                icon: CupertinoIcons.pencil,
                label: l10n.subjectDetailEdit,
                color: scheme.onSurface,
                onTap: () => unawaited(
                  showTestFormSheet(
                    context,
                    controller: controller,
                    editing: test,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _ActionChip(
                key: ValueKey('test-delete-${test.id}'),
                icon: CupertinoIcons.trash,
                label: l10n.subjectsDelete,
                color: AppColors.red500,
                onTap: () => unawaited(_confirmDelete(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelsTab extends StatelessWidget {
  const _LevelsTab({required this.controller});

  final SubjectDetailController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () =>
                unawaited(showLevelFormSheet(context, controller: controller)),
            icon: const Icon(CupertinoIcons.add, size: 18),
            label: Text(l10n.subjectDetailAddLevel),
          ),
        ),
        const SizedBox(height: 16),
        if (controller.isLoadingLevels && controller.levels.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (controller.hasLevelsError)
          _ErrorState(
            message: l10n.subjectDetailLevelsLoadError,
            onRetry: () => unawaited(controller.loadLevels()),
          )
        else if (controller.levels.isEmpty)
          _EmptyState(
            icon: CupertinoIcons.square_stack_3d_up,
            title: l10n.subjectDetailLevelsEmptyTitle,
            description: l10n.subjectDetailLevelsEmptyDescription,
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                for (var i = 0; i < controller.levels.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                  _LevelRow(
                    level: controller.levels[i],
                    controller: controller,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({required this.level, required this.controller});

  final Level level;
  final SubjectDetailController controller;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.subjectDetailDeleteLevelConfirmTitle(level.name)),
        content: Text(l10n.subjectDetailDeleteLevelConfirmDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.subjectsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteLevel(level.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectDetailLevelDeleteError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          CupertinoIcons.square_stack_3d_up_fill,
          size: 16,
          color: scheme.primary,
        ),
      ),
      title: Text(level.name, style: Theme.of(context).textTheme.titleSmall),
      trailing: PopupMenuButton<_LevelAction>(
        icon: Icon(
          CupertinoIcons.ellipsis_vertical,
          color: scheme.onSurfaceVariant,
        ),
        onSelected: (action) {
          unawaited(
            Future<void>.delayed(Duration.zero).then((_) {
              if (!context.mounted) return Future<void>.value();
              switch (action) {
                case _LevelAction.rename:
                  return showLevelFormSheet(
                    context,
                    controller: controller,
                    editing: level,
                  );
                case _LevelAction.delete:
                  return _confirmDelete(context);
              }
            }),
          );
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            key: ValueKey('level-rename-${level.id}'),
            value: _LevelAction.rename,
            child: Text(l10n.subjectsRename),
          ),
          PopupMenuItem(
            key: ValueKey('level-delete-${level.id}'),
            value: _LevelAction.delete,
            child: Text(
              l10n.subjectsDelete,
              style: TextStyle(color: scheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

enum _LevelAction { rename, delete }

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    this.description,
  });

  final IconData icon;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: scheme.primary),
          ),
          const SizedBox(height: 18),
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
      padding: const EdgeInsets.only(top: 40),
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
