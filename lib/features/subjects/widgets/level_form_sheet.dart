import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/subjects/domain/level.dart';
import 'package:studify/features/subjects/subject_detail_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/rename level sheet. Pass [editing] to rename that
/// level; omit it to add a new one to the subject.
Future<void> showLevelFormSheet(
  BuildContext context, {
  required SubjectDetailController controller,
  Level? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _LevelFormSheet(controller: controller, editing: editing),
  );
}

class _LevelFormSheet extends StatefulWidget {
  const _LevelFormSheet({required this.controller, this.editing});

  final SubjectDetailController controller;
  final Level? editing;

  @override
  State<_LevelFormSheet> createState() => _LevelFormSheetState();
}

class _LevelFormSheetState extends State<_LevelFormSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.editing?.name ?? '',
  );
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.editing != null;

  bool get _canSubmit => _name.text.trim().isNotEmpty && !_submitting;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    try {
      final editing = widget.editing;
      if (editing == null) {
        await widget.controller.createLevel(name);
      } else {
        await widget.controller.renameLevel(editing.id, name);
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
                      ? l10n.subjectDetailLevelUpdateError
                      : l10n.subjectDetailLevelCreateError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                    ? l10n.subjectDetailRenameLevelModalTitle
                    : l10n.subjectDetailAddLevelModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('level-form-name'),
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: l10n.subjectDetailLevelNamePlaceholder,
                  filled: true,
                  fillColor: scheme.surfaceContainerLowest.withValues(
                    alpha: 0.92,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    borderSide: BorderSide(color: scheme.outlineVariant),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _submit(),
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
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Text(
                          _isEditing
                              ? l10n.subjectsSave
                              : l10n.subjectDetailCreateLevel,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
