import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/students/students_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add-student sheet (teachers only).
Future<void> showAddStudentSheet(
  BuildContext context, {
  required StudentsController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _AddStudentSheet(controller: controller),
  );
}

class _AddStudentSheet extends StatefulWidget {
  const _AddStudentSheet({required this.controller});

  final StudentsController controller;

  @override
  State<_AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<_AddStudentSheet> {
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  int? _subjectId;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !_submitting &&
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _password.text.isNotEmpty &&
      _subjectId != null;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    try {
      await widget.controller.addStudent(
        name: _name.text.trim(),
        surname: _surname.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        subjectId: _subjectId!,
      );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.studentsServerUnavailable
            : error.statusCode == 409
            ? l10n.studentsEmailTaken
            : error.message ?? l10n.studentsCreateError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subjects = widget.controller.subjects;

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
              Text(l10n.studentsAddStudent, style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: decoration(l10n.studentsNameLabel),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _surname,
                textCapitalization: TextCapitalization.words,
                decoration: decoration(l10n.studentsSurnameLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: decoration(l10n.studentsEmailLabel),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: decoration(l10n.studentsPasswordLabel),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.studentsPasswordHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              if (subjects.isEmpty)
                _Hint(l10n.studentsNoSubjects)
              else
                PickerPill<int?>(
                  key: const ValueKey('add-student-subject'),
                  value: _subjectId,
                  label:
                      subjects
                          .where((s) => s.id == _subjectId)
                          .firstOrNull
                          ?.name ??
                      l10n.studentsSubjectLabel,
                  options: [
                    for (final subject in subjects)
                      (value: subject.id, label: subject.name),
                  ],
                  onChanged: (id) => setState(() => _subjectId = id),
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
                      : Text(l10n.studentsCreate),
                ),
              ),
            ],
          ),
        ),
      ),
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
        borderRadius: BorderRadius.circular(14),
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
