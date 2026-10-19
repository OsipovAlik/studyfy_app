import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/subject_detail_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

const _cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// Opens the "Generate with AI" sheet for the currently selected level.
/// Returns the generated/requested question counts on success, so the
/// caller can tell the teacher if the AI fell short — null if the sheet
/// was dismissed without generating.
Future<GeneratedTest?> showGenerateTestSheet(
  BuildContext context, {
  required SubjectDetailController controller,
}) {
  return showModalBottomSheet<GeneratedTest>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _GenerateTestSheet(controller: controller),
  );
}

class _GenerateTestSheet extends StatefulWidget {
  const _GenerateTestSheet({required this.controller});

  final SubjectDetailController controller;

  @override
  State<_GenerateTestSheet> createState() => _GenerateTestSheetState();
}

class _GenerateTestSheetState extends State<_GenerateTestSheet> {
  final _topic = TextEditingController();
  final _title = TextEditingController();
  final _instructions = TextEditingController();
  final _timeLimit = TextEditingController();
  final _questionCount = TextEditingController(text: '10');
  String _cefrLevel = 'A1';
  String _questionType = 'mixed';
  String? _error;

  bool get _submitting => widget.controller.isGenerating;

  bool get _canSubmit {
    final count = int.tryParse(_questionCount.text.trim());
    return !_submitting &&
        _topic.text.trim().isNotEmpty &&
        count != null &&
        count >= 1 &&
        count <= 30;
  }

  @override
  void dispose() {
    _topic.dispose();
    _title.dispose();
    _instructions.dispose();
    _timeLimit.dispose();
    _questionCount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final topic = _topic.text.trim();
    final count = int.tryParse(_questionCount.text.trim());
    if (topic.isEmpty || count == null) return;

    setState(() => _error = null);
    final l10n = AppLocalizations.of(context);
    try {
      final result = await widget.controller.generateTest(
        topic: topic,
        cefrLevel: _cefrLevel,
        questionCount: count,
        questionType: _questionType,
        title: _title.text.trim(),
        instructions: _instructions.text.trim(),
        timeLimitMinutes: int.tryParse(_timeLimit.text.trim()),
      );
      if (mounted) Navigator.of(context).pop(result);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.isTooManyRequests
            ? l10n.subjectDetailGenerateRateLimited
            : error.statusCode == 503
            ? l10n.subjectDetailGenerateUnavailable
            : (error.isNetworkError || error.isServerError)
            ? l10n.subjectDetailGenerateFailed
            : error.message ?? l10n.subjectDetailGenerateFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    InputDecoration decoration(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    );

    return SafeArea(
      child: AbsorbPointer(
        absorbing: _submitting,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.subjectDetailGenerateModalTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _topic,
                  autofocus: true,
                  decoration: decoration(
                    l10n.subjectDetailGenerateTopicPlaceholder,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PickerPill<String>(
                        value: _cefrLevel,
                        label: _cefrLevel,
                        options: [
                          for (final level in _cefrLevels)
                            (value: level, label: level),
                        ],
                        onChanged: (value) =>
                            setState(() => _cefrLevel = value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _questionCount,
                        keyboardType: TextInputType.number,
                        decoration: decoration(
                          l10n.subjectDetailGenerateQuestionCountLabel,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PickerPill<String>(
                  value: _questionType,
                  label: switch (_questionType) {
                    'multiple_choice' =>
                      l10n.subjectDetailGenerateQuestionTypeMultipleChoice,
                    'text' => l10n.subjectDetailGenerateQuestionTypeText,
                    _ => l10n.subjectDetailGenerateQuestionTypeMixed,
                  },
                  options: [
                    (
                      value: 'mixed',
                      label: l10n.subjectDetailGenerateQuestionTypeMixed,
                    ),
                    (
                      value: 'multiple_choice',
                      label:
                          l10n.subjectDetailGenerateQuestionTypeMultipleChoice,
                    ),
                    (
                      value: 'text',
                      label: l10n.subjectDetailGenerateQuestionTypeText,
                    ),
                  ],
                  onChanged: (value) => setState(() => _questionType = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _title,
                  decoration: decoration(l10n.subjectDetailGenerateTitleLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _instructions,
                  maxLines: 3,
                  decoration: decoration(
                    l10n.subjectDetailGenerateInstructionsLabel,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _timeLimit,
                  keyboardType: TextInputType.number,
                  decoration: decoration(l10n.subjectDetailTimeLimitHint),
                ),
                if (_error case final error?) ...[
                  const SizedBox(height: 16),
                  Text(error, style: TextStyle(color: scheme.error)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canSubmit ? _submit : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _submitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: scheme.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  l10n.subjectDetailGenerating,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : Text(l10n.subjectDetailGenerateButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
