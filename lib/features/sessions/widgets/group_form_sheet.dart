import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/sessions/domain/group.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/rename group sheet. Pass [editing] to rename that
/// group (no member picker — membership is managed from the group's own
/// detail screen); omit it to create a new one, optionally with an
/// initial set of members.
Future<void> showGroupFormSheet(
  BuildContext context, {
  required TimetableController controller,
  Group? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _GroupFormSheet(controller: controller, editing: editing),
  );
}

class _GroupFormSheet extends StatefulWidget {
  const _GroupFormSheet({required this.controller, this.editing});

  final TimetableController controller;
  final Group? editing;

  @override
  State<_GroupFormSheet> createState() => _GroupFormSheetState();
}

class _GroupFormSheetState extends State<_GroupFormSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.editing?.name ?? '',
  );
  final Set<int> _selectedStudentIds = {};
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
        await widget.controller.createGroup(
          name: name,
          studentIds: _selectedStudentIds.toList(),
        );
      } else {
        await widget.controller.renameGroup(editing.id, name);
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.groupsServerUnavailable
            : error.message ??
                  (_isEditing
                      ? l10n.groupsUpdateError
                      : l10n.groupsCreateError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final studentNames = widget.controller.studentNames;

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
                    ? l10n.groupsRenameModalTitle
                    : l10n.groupsAddModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _FieldLabel(l10n.groupsNameLabel),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey('group-form-name'),
                controller: _name,
                autofocus: !_isEditing,
                decoration: InputDecoration(
                  hintText: l10n.groupsNamePlaceholder,
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
              ),
              if (!_isEditing) ...[
                const SizedBox(height: 16),
                _FieldLabel(l10n.groupsMembersLabel),
                const SizedBox(height: 8),
                if (studentNames.isEmpty)
                  _Hint(l10n.groupsNoStudentsHint)
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 220),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: [
                        for (final entry in studentNames.entries)
                          CheckboxListTile(
                            key: ValueKey('group-form-student-${entry.key}'),
                            dense: true,
                            value: _selectedStudentIds.contains(entry.key),
                            title: Text(entry.value),
                            onChanged: (checked) => setState(() {
                              if (checked ?? false) {
                                _selectedStudentIds.add(entry.key);
                              } else {
                                _selectedStudentIds.remove(entry.key);
                              }
                            }),
                          ),
                      ],
                    ),
                  ),
              ],
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
                      : Text(_isEditing ? l10n.groupsSave : l10n.groupsCreate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
