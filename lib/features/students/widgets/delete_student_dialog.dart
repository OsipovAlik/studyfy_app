import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/features/students/students_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the delete-student dialog (used from the roster row and the
/// student detail page).
Future<void> showDeleteStudentDialog(
  BuildContext context, {
  required Student student,
  required StudentsController controller,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _DeleteStudentDialog(student: student, controller: controller),
  );
}

/// Deleting a student requires the *teacher's own* password to confirm
/// (the API's rule, not ours) — so unlike a plain yes/no confirm, this
/// stays open on a wrong password instead of closing, so they can retry.
class _DeleteStudentDialog extends StatefulWidget {
  const _DeleteStudentDialog({required this.student, required this.controller});

  final Student student;
  final StudentsController controller;

  @override
  State<_DeleteStudentDialog> createState() => _DeleteStudentDialogState();
}

class _DeleteStudentDialogState extends State<_DeleteStudentDialog> {
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text.isEmpty || _submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    try {
      await widget.controller.deleteStudent(
        widget.student.id,
        password: _password.text,
      );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.studentsServerUnavailable
            : error.message == 'Password is incorrect'
            ? l10n.studentsDeletePasswordIncorrect
            : error.message ==
                  "This student also studies other teachers' subjects; only "
                      "the school's owner can delete them"
            ? l10n.studentsDeleteForbidden
            : l10n.studentsDeleteError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l10n.studentsDeleteConfirmTitle(widget.student.fullName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.studentsDeleteConfirmDescription),
          const SizedBox(height: 4),
          Text(l10n.studentsDeletePasswordPrompt),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            autofocus: true,
            obscureText: true,
            enabled: !_submitting,
            decoration: InputDecoration(hintText: l10n.studentsPasswordLabel),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => unawaited(_submit()),
          ),
          if (_error case final error?) ...[
            const SizedBox(height: 8),
            Text(error, style: TextStyle(color: scheme.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error),
          onPressed: (_submitting || _password.text.isEmpty)
              ? null
              : () => unawaited(_submit()),
          child: _submitting
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onError,
                  ),
                )
              : Text(l10n.studentsDelete),
        ),
      ],
    );
  }
}
