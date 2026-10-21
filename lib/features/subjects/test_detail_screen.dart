import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/features/homework/widgets/homework_row.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/results_list_controller.dart';
import 'package:studify/features/subjects/data/levels_repository.dart';
import 'package:studify/features/subjects/data/questions_repository.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/domain/test.dart';
import 'package:studify/features/subjects/test_detail_controller.dart';
import 'package:studify/features/subjects/widgets/question_form_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

enum _Tab { questions, results, homework }

/// One test's own page: its draft/published status, questions, and (via
/// the app-wide results/homework controllers, filtered to this test)
/// its attempts and assignments. Reached by tapping a test on the
/// subject detail screen; teacher-only, same as that screen.
class TestDetailScreen extends StatefulWidget {
  const TestDetailScreen({required this.testId, this.initialTest, super.key});

  final int testId;

  /// The tapped test, carried over navigation so this page doesn't need
  /// to refetch it; null on a cold deep link, where it's loaded instead.
  final Test? initialTest;

  @override
  State<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  late final TestDetailController _controller;
  _Tab _tab = _Tab.questions;

  @override
  void initState() {
    super.initState();
    _controller = TestDetailController(
      testId: widget.testId,
      tests: context.read<TestsRepository>(),
      questions: context.read<QuestionsRepository>(),
      levels: context.read<LevelsRepository>(),
      initialTest: widget.initialTest,
    )..addListener(_handleChange);
    unawaited(_controller.ensureLoaded());
    unawaited(context.read<ResultsListController>().ensureLoaded());
    unawaited(context.read<HomeworkController>().ensureLoaded());
  }

  void _handleChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChange)
      ..dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _controller.setActive(isActive: true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.testDetailPublishError,
          ),
        ),
      );
    }
  }

  Future<void> _unpublish() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _controller.setActive(isActive: false);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.testDetailPublishError,
          ),
        ),
      );
    }
  }

  Future<void> _discardDraft() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.testDetailDiscardDraftConfirmTitle),
        content: Text(l10n.testDetailDiscardDraftConfirmDescription),
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
            child: Text(l10n.testDetailDiscardDraft),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _controller.deleteTest();
      if (mounted) context.pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.testDetailDiscardError,
          ),
        ),
      );
    }
  }

  Future<void> _deleteQuestion(Question question) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.testDetailDeleteQuestionConfirmTitle),
        content: Text(l10n.testDetailDeleteQuestionConfirmDescription),
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
    if (confirmed != true || !mounted) return;

    try {
      await _controller.deleteQuestion(question.id);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.testDetailQuestionDeleteError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final test = _controller.test;
    final resultsCount = context
        .watch<ResultsListController>()
        .results
        .where((r) => r.testId == widget.testId)
        .length;
    final homeworkCount = context
        .watch<HomeworkController>()
        .assignments
        .where((a) => a.testId == widget.testId)
        .length;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: test == null
                ? (_controller.isLoadingTest
                      ? const Center(child: CircularProgressIndicator())
                      : _NotFound(message: l10n.testDetailNotFoundDescription))
                : RefreshIndicator(
                    onRefresh: _controller.reload,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const _BackRow(),
                        const SizedBox(height: 16),
                        if (!test.isActive) ...[
                          _DraftBanner(
                            busy: _controller.isMutatingTest,
                            onDiscard: _discardDraft,
                            onPublish: _publish,
                          ),
                          const SizedBox(height: 16),
                        ],
                        _HeroCard(test: test, levelName: _controller.levelName),
                        if (test.isActive) ...[
                          const SizedBox(height: 12),
                          _UnpublishRow(
                            busy: _controller.isMutatingTest,
                            onUnpublish: _unpublish,
                          ),
                        ],
                        const SizedBox(height: 20),
                        _SegmentedTabs(
                          tab: _tab,
                          resultsCount: resultsCount,
                          homeworkCount: homeworkCount,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 16),
                        switch (_tab) {
                          _Tab.questions => _QuestionsTab(
                            controller: _controller,
                            onAdd: () => unawaited(
                              showQuestionFormSheet(
                                context,
                                controller: _controller,
                              ),
                            ),
                            onEdit: (question) => unawaited(
                              showQuestionFormSheet(
                                context,
                                controller: _controller,
                                editing: question,
                              ),
                            ),
                            onDelete: _deleteQuestion,
                          ),
                          _Tab.results => _ResultsTab(testId: widget.testId),
                          _Tab.homework => _HomeworkTab(testId: widget.testId),
                        },
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
        child: Icon(
          CupertinoIcons.back,
          size: 22,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DraftBanner extends StatelessWidget {
  const _DraftBanner({
    required this.busy,
    required this.onDiscard,
    required this.onPublish,
  });

  final bool busy;
  final VoidCallback onDiscard;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.amber500.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.amber500.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.amber500.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  CupertinoIcons.sparkles,
                  size: 15,
                  color: AppColors.amber500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.testDetailDraftBannerTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.amber500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onDiscard,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.amber500,
                    side: const BorderSide(color: AppColors.amber500),
                  ),
                  child: Text(l10n.testDetailDiscardDraft),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : onPublish,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.amber500,
                  ),
                  child: Text(l10n.testDetailPublishTest),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnpublishRow extends StatelessWidget {
  const _UnpublishRow({required this.busy, required this.onUnpublish});

  final bool busy;
  final VoidCallback onUnpublish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: busy ? null : onUnpublish,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.bolt_fill,
                size: 15,
                color: AppColors.amber500,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.subjectsDeactivate,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.amber500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.test, required this.levelName});

  final Test test;
  final String? levelName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final statusColor = test.isActive ? AppColors.emerald400 : Colors.white70;
    final duration = test.timeLimitMinutes == null
        ? l10n.testDetailUntimedLabel
        : l10n.testDetailMinutesLabel(test.timeLimitMinutes!);

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
              CupertinoIcons.doc_text_fill,
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            test.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      test.isActive
                          ? l10n.subjectsActiveLabel
                          : l10n.subjectsInactiveLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _Pill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.time,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      duration,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (levelName case final name?)
                _Pill(
                  child: Text(
                    name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
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

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tab,
    required this.resultsCount,
    required this.homeworkCount,
    required this.onChanged,
  });

  final _Tab tab;
  final int resultsCount;
  final int homeworkCount;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget segment({required _Tab value, required String label}) {
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
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
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
          segment(value: _Tab.questions, label: l10n.testDetailTabQuestions),
          segment(
            value: _Tab.results,
            label: l10n.testDetailTabResults(resultsCount),
          ),
          segment(
            value: _Tab.homework,
            label: l10n.testDetailTabHomework(homeworkCount),
          ),
        ],
      ),
    );
  }
}

class _QuestionsTab extends StatelessWidget {
  const _QuestionsTab({
    required this.controller,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final TestDetailController controller;
  final VoidCallback onAdd;
  final ValueChanged<Question> onEdit;
  final ValueChanged<Question> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.testDetailTabQuestions, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          l10n.testDetailQuestionsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(CupertinoIcons.add, size: 18),
            label: Text(l10n.testDetailAddQuestion),
          ),
        ),
        const SizedBox(height: 16),
        if (controller.isLoadingQuestions && controller.questions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (controller.hasQuestionsError)
          _InlineError(message: l10n.testDetailQuestionsLoadError)
        else
          for (var i = 0; i < controller.questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _QuestionCard(
                index: i + 1,
                question: controller.questions[i],
                onEdit: () => onEdit(controller.questions[i]),
                onDelete: () => onDelete(controller.questions[i]),
              ),
            ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final Question question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isMultipleChoice = question.type == QuestionType.multipleChoice;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '$index. ${isMultipleChoice ? l10n.subjectDetailGenerateQuestionTypeMultipleChoice : l10n.testDetailFreeTextLabel}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onDelete,
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 16,
                  color: AppColors.red500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(question.question, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          if (isMultipleChoice)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in const ['a1', 'a2', 'a3', 'a4'])
                  if (question.options[key] case final label?)
                    _OptionPill(
                      label: label,
                      isCorrect: question.rightAnswer == key,
                    ),
              ],
            )
          else if (question.rightAnswer case final expected?)
            Text(
              l10n.testDetailExpectedAnswerLabel(expected),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionPill extends StatelessWidget {
  const _OptionPill({required this.label, required this.isCorrect});

  final String label;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isCorrect ? AppColors.emerald500 : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.emerald500.withValues(alpha: 0.14)
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: isCorrect
            ? Border.all(color: AppColors.emerald500.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCorrect) ...[
            const Icon(
              CupertinoIcons.check_mark_circled_solid,
              size: 13,
              color: AppColors.emerald500,
            ),
            const SizedBox(width: 5),
          ],
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _ResultsTab extends StatelessWidget {
  const _ResultsTab({required this.testId});

  final int testId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = context.watch<ResultsListController>();

    if (controller.isLoading && controller.results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.hasError) {
      return _InlineError(message: l10n.resultsLoadError);
    }

    final results = controller.results
        .where((r) => r.testId == testId)
        .toList();
    if (results.isEmpty) {
      return _EmptyHint(text: l10n.testDetailResultsEmptyTitle);
    }

    final locale = Localizations.localeOf(context).toLanguageTag();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            _ResultRow(
              result: results[i],
              studentName: controller.isTeacher
                  ? controller.studentName(results[i].studentId, l10n)
                  : null,
              locale: locale,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.result,
    required this.studentName,
    required this.locale,
  });

  final Result result;
  final String? studentName;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final percent = result.percentage.round();
    final color = percent >= 70
        ? AppColors.emerald500
        : percent >= 40
        ? AppColors.amber500
        : AppColors.red500;
    final created = result.createdAt;
    final dateLabel = created == null
        ? null
        : DateFormat.yMMMd(locale).add_jm().format(created.toLocal());
    final subtitleParts = [?studentName, ?dateLabel];

    return ListTile(
      onTap: () => context.push('${AppRoutes.results}/${result.id}'),
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
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
        '${result.score} / ${result.total}',
        style: theme.textTheme.titleSmall,
      ),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(
              subtitleParts.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
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

class _HomeworkTab extends StatelessWidget {
  const _HomeworkTab({required this.testId});

  final int testId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final controller = context.watch<HomeworkController>();

    if (controller.isLoading && controller.assignments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.hasError) {
      return _InlineError(message: l10n.homeworkLoadError);
    }

    final assignments = controller.assignments
        .where((a) => a.testId == testId)
        .toList();
    if (assignments.isEmpty) {
      return _EmptyHint(text: l10n.testDetailHomeworkEmptyTitle);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < assignments.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            HomeworkRow(
              assignment: assignments[i],
              showStudentName: controller.isTeacher,
              onTap: () => context.push(
                '${AppRoutes.homework}/${assignments[i].id}',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
