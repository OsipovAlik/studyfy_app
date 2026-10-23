import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/subjects/test_detail_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/edit question sheet. Pass [editing] to change that
/// question; omit it to add a new one to [controller]'s test.
Future<void> showQuestionFormSheet(
  BuildContext context, {
  required TestDetailController controller,
  Question? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) =>
        _QuestionFormSheet(controller: controller, editing: editing),
  );
}

class _QuestionFormSheet extends StatefulWidget {
  const _QuestionFormSheet({required this.controller, this.editing});

  final TestDetailController controller;
  final Question? editing;

  @override
  State<_QuestionFormSheet> createState() => _QuestionFormSheetState();
}

class _QuestionFormSheetState extends State<_QuestionFormSheet> {
  late QuestionType _type = widget.editing?.type == QuestionType.text
      ? QuestionType.text
      : QuestionType.multipleChoice;
  late final TextEditingController _question = TextEditingController(
    text: widget.editing?.question ?? '',
  );
  late final TextEditingController _a1 = TextEditingController(
    text: widget.editing?.options['a1'] ?? '',
  );
  late final TextEditingController _a2 = TextEditingController(
    text: widget.editing?.options['a2'] ?? '',
  );
  late final TextEditingController _a3 = TextEditingController(
    text: widget.editing?.options['a3'] ?? '',
  );
  late final TextEditingController _a4 = TextEditingController(
    text: widget.editing?.options['a4'] ?? '',
  );
  late final TextEditingController _expectedAnswer = TextEditingController(
    text: widget.editing?.type == QuestionType.text
        ? widget.editing?.rightAnswer ?? ''
        : '',
  );
  late final TextEditingController _video = TextEditingController(
    text: widget.editing?.video ?? '',
  );
  late String? _correctOption =
      widget.editing?.type == QuestionType.multipleChoice
      ? widget.editing?.rightAnswer
      : null;

  PlatformFile? _newImage;
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.editing != null;

  @override
  void dispose() {
    _question.dispose();
    _a1.dispose();
    _a2.dispose();
    _a3.dispose();
    _a4.dispose();
    _expectedAnswer.dispose();
    _video.dispose();
    super.dispose();
  }

  List<MapEntry<String, TextEditingController>> get _optionControllers => [
    MapEntry('a1', _a1),
    MapEntry('a2', _a2),
    MapEntry('a3', _a3),
    MapEntry('a4', _a4),
  ];

  bool get _canSubmit {
    if (_submitting || _question.text.trim().isEmpty) return false;
    if (_type == QuestionType.text) {
      return _expectedAnswer.text.trim().isNotEmpty;
    }
    final filled =
        _correctOption != null &&
        (_optionControllers
            .firstWhere((e) => e.key == _correctOption)
            .value
            .text
            .trim()
            .isNotEmpty);
    return _a1.text.trim().isNotEmpty && _a2.text.trim().isNotEmpty && filled;
  }

  Future<void> _pickImage() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null) return;
    setState(() => _newImage = file);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final question = _question.text.trim();
    if (question.isEmpty || !_canSubmit) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final rightAnswer = _type == QuestionType.text
        ? _expectedAnswer.text.trim()
        : _correctOption!;
    final video = _video.text.trim();

    try {
      final editing = widget.editing;
      if (editing == null) {
        await widget.controller.addQuestion(
          question: question,
          type: _type,
          rightAnswer: rightAnswer,
          a1: _type == QuestionType.multipleChoice ? _a1.text.trim() : null,
          a2: _type == QuestionType.multipleChoice ? _a2.text.trim() : null,
          a3: _type == QuestionType.multipleChoice
              ? _a3.text.trim().isEmpty
                    ? null
                    : _a3.text.trim()
              : null,
          a4: _type == QuestionType.multipleChoice
              ? _a4.text.trim().isEmpty
                    ? null
                    : _a4.text.trim()
              : null,
          image: _newImage,
          video: video.isEmpty ? null : video,
        );
      } else {
        await widget.controller.editQuestion(
          editing.id,
          question: question,
          type: _type,
          rightAnswer: rightAnswer,
          a1: _type == QuestionType.multipleChoice ? _a1.text.trim() : null,
          a2: _type == QuestionType.multipleChoice ? _a2.text.trim() : null,
          a3: _type == QuestionType.multipleChoice ? _a3.text.trim() : null,
          a4: _type == QuestionType.multipleChoice ? _a4.text.trim() : null,
          image: _newImage,
          video: video,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.subjectsServerUnavailable
            : error.message ??
                  (_isEditing
                      ? l10n.testDetailQuestionUpdateError
                      : l10n.testDetailQuestionCreateError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    InputDecoration decoration([String? hint]) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    );

    Widget labeled(String label, Widget field) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );

    Widget optionField(String key, String label) {
      final fieldController = _optionControllers
          .firstWhere((e) => e.key == key)
          .value;
      return labeled(
        label,
        TextField(
          key: ValueKey('question-form-option-$key'),
          controller: fieldController,
          decoration: decoration(),
          onChanged: (_) => setState(() {}),
        ),
      );
    }

    final filledOptions = [
      for (final entry in _optionControllers)
        if (entry.value.text.trim().isNotEmpty) entry,
    ];
    if (_correctOption != null &&
        !filledOptions.any((e) => e.key == _correctOption)) {
      _correctOption = null;
    }

    return SafeArea(
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
                _isEditing
                    ? l10n.testDetailQuestionFormEditTitle
                    : l10n.testDetailQuestionFormAddTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              labeled(
                l10n.testDetailQuestionLabel,
                TextField(
                  key: const ValueKey('question-form-text'),
                  controller: _question,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: decoration(
                    l10n.testDetailQuestionTextPlaceholder,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              labeled(
                l10n.testDetailImageLabel,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(CupertinoIcons.photo, size: 16),
                          label: Text(l10n.testDetailAddImage),
                        ),
                        if (_newImage != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _newImage!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _newImage = null),
                            icon: const Icon(
                              CupertinoIcons.xmark_circle_fill,
                              size: 18,
                            ),
                          ),
                        ] else if (widget.editing?.imageUrl != null) ...[
                          const SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppTheme.cardRadius,
                            ),
                            child: Image.network(
                              widget.editing!.imageUrl!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.editing?.imageUrl != null
                          ? l10n.testDetailImageHelpExisting
                          : l10n.testDetailImageHelpNew,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              labeled(
                l10n.testDetailVideoPlaceholder,
                TextField(
                  key: const ValueKey('question-form-video'),
                  controller: _video,
                  decoration: decoration(l10n.testDetailVideoHint),
                ),
              ),
              labeled(
                l10n.testDetailQuestionTypeLabel,
                DropdownButtonFormField<QuestionType>(
                  key: const ValueKey('question-form-type'),
                  initialValue: _type,
                  decoration: decoration(),
                  items: [
                    DropdownMenuItem(
                      value: QuestionType.multipleChoice,
                      child: Text(
                        l10n.subjectDetailGenerateQuestionTypeMultipleChoice,
                      ),
                    ),
                    DropdownMenuItem(
                      value: QuestionType.text,
                      child: Text(l10n.subjectDetailGenerateQuestionTypeText),
                    ),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? _type),
                ),
              ),
              if (_type == QuestionType.multipleChoice) ...[
                optionField('a1', l10n.testDetailOptionLabel('1')),
                optionField('a2', l10n.testDetailOptionLabel('2')),
                optionField('a3', l10n.testDetailOptionOptionalLabel('3')),
                optionField('a4', l10n.testDetailOptionOptionalLabel('4')),
                labeled(
                  l10n.testDetailCorrectAnswerLabel,
                  DropdownButtonFormField<String>(
                    key: const ValueKey('question-form-correct-option'),
                    initialValue: _correctOption,
                    decoration: decoration(),
                    items: [
                      for (final entry in filledOptions)
                        DropdownMenuItem(
                          value: entry.key,
                          child: Text(
                            entry.value.text.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) =>
                        setState(() => _correctOption = value),
                  ),
                ),
              ] else
                labeled(
                  l10n.testDetailExpectedTextAnswerPlaceholder,
                  TextField(
                    key: const ValueKey('question-form-expected-answer'),
                    controller: _expectedAnswer,
                    decoration: decoration(),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              if (_error case final error?) ...[
                Text(error, style: TextStyle(color: scheme.error)),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _submitting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Text(l10n.testDetailSaveQuestion),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
