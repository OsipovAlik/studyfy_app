import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/subjects/domain/subject.dart';
import 'package:studify/features/subjects/subjects_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/rename subject sheet. Pass [editing] to rename that
/// subject; omit it to create a new one (it starts inactive, same as the
/// API's own default).
Future<void> showSubjectFormSheet(
  BuildContext context, {
  required SubjectsController controller,
  Subject? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) =>
        _SubjectFormSheet(controller: controller, editing: editing),
  );
}

class _SubjectFormSheet extends StatefulWidget {
  const _SubjectFormSheet({required this.controller, this.editing});

  final SubjectsController controller;
  final Subject? editing;

  @override
  State<_SubjectFormSheet> createState() => _SubjectFormSheetState();
}

class _SubjectFormSheetState extends State<_SubjectFormSheet> {
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
        await widget.controller.createSubject(name);
      } else {
        await widget.controller.renameSubject(editing.id, name);
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
                      ? l10n.subjectsUpdateError
                      : l10n.subjectsCreateError);
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
                    ? l10n.subjectsRenameModalTitle
                    : l10n.subjectsAddModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('subject-form-name'),
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: l10n.subjectsNamePlaceholder,
                  filled: true,
                  fillColor: scheme.surfaceContainerLowest.withValues(
                    alpha: 0.92,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
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
                          _isEditing ? l10n.subjectsSave : l10n.subjectsCreate,
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
