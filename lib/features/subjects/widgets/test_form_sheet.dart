import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
import 'package:studify/features/subjects/domain/test.dart';
import 'package:studify/features/subjects/subject_detail_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/edit test sheet. Pass [editing] to change that test's
/// title and time limit; omit it to add a new test to the currently
/// selected level.
Future<void> showTestFormSheet(
  BuildContext context, {
  required SubjectDetailController controller,
  Test? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _TestFormSheet(controller: controller, editing: editing),
  );
}

class _TestFormSheet extends StatefulWidget {
  const _TestFormSheet({required this.controller, this.editing});

  final SubjectDetailController controller;
  final Test? editing;

  @override
  State<_TestFormSheet> createState() => _TestFormSheetState();
}

class _TestFormSheetState extends State<_TestFormSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.editing?.title ?? '',
  );
  late final TextEditingController _timeLimit = TextEditingController(
    text: widget.editing?.timeLimitMinutes?.toString() ?? '',
  );
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.editing != null;

  bool get _canSubmit => _title.text.trim().isNotEmpty && !_submitting;

  @override
  void dispose() {
    _title.dispose();
    _timeLimit.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    final minutes = int.tryParse(_timeLimit.text.trim());
    try {
      final editing = widget.editing;
      if (editing == null) {
        await widget.controller.createTest(
          title: title,
          timeLimitMinutes: minutes,
        );
      } else {
        // Blank clears the limit (PATCH's own meaning for `0`), a
        // number sets it; there's no "leave unchanged" in this form
        // since it's always pre-filled with the current value.
        await widget.controller.updateTest(
          editing.id,
          title: title,
          timeLimitMinutes: minutes ?? 0,
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
                      ? l10n.subjectDetailTestUpdateError
                      : l10n.subjectDetailTestCreateError);
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
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    );

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
                    ? l10n.subjectDetailEditTestModalTitle
                    : l10n.subjectDetailAddTestModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('test-form-title'),
                controller: _title,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: decoration(l10n.subjectDetailTestTitlePlaceholder),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('test-form-time-limit'),
                controller: _timeLimit,
                keyboardType: TextInputType.number,
                decoration: decoration(l10n.subjectDetailTimeLimitHint),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.subjectDetailTimeLimitLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (_error case final error?) ...[
                const SizedBox(height: 16),
                Text(error, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BusyButton(
                  label: _isEditing
                      ? l10n.subjectsSave
                      : l10n.subjectDetailCreateTest,
                  busy: _submitting,
                  showArrow: true,
                  onPressed: _canSubmit ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
