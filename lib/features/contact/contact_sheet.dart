import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
import 'package:studify/features/contact/contact_repository.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the "Registration" form: a school leaves an email and phone
/// number and the Studyfy team gets back to them.
Future<void> showContactSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const ContactSheet(),
  );
}

class ContactSheet extends StatefulWidget {
  const ContactSheet({super.key});

  @override
  State<ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<ContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  bool _sending = false;
  bool _sent = false;
  String? _error;

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _phoneSeparators = RegExp(r'[\s\-().]');
  static final _phonePattern = RegExp(r'^\+?\d{8,15}$');

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await context.read<ContactRepository>().sendRequest(
        email: _email.text.trim(),
        phone: _phone.text.trim(),
      );
      if (mounted) setState(() => _sent = true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFor(e, l10n));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String _messageFor(ApiException e, AppLocalizations l10n) {
    if (e.isNetworkError) return l10n.errorServerUnavailable;
    if (e.isTooManyRequests) {
      final seconds = e.retryAfter?.inSeconds ?? 600;
      final time = seconds < 60
          ? l10n.durationSeconds(seconds)
          : l10n.durationMinutes((seconds / 60).ceil());
      return l10n.registrationTooMany(time);
    }
    if (e.isValidation && e.message != null) return e.message!;
    return l10n.errorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: _sent ? _buildSuccess(context) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.registrationTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            l10n.registrationSub,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _email,
            enabled: !_sending,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l10n.registrationEmailLabel,
              prefixIcon: const Icon(CupertinoIcons.mail),
            ),
            validator: (value) => _emailPattern.hasMatch(value?.trim() ?? '')
                ? null
                : l10n.registrationInvalidEmail,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phone,
            enabled: !_sending,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: l10n.registrationPhoneLabel,
              hintText: l10n.registrationPhonePlaceholder,
              prefixIcon: const Icon(CupertinoIcons.phone),
            ),
            validator: (value) {
              final digits = (value ?? '').replaceAll(_phoneSeparators, '');
              return _phonePattern.hasMatch(digits)
                  ? null
                  : l10n.registrationInvalidPhone;
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 24),
          BusyButton(
            label: l10n.registrationSubmit,
            busyLabel: l10n.registrationSending,
            busy: _sending,
            showArrow: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.emerald500,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.checkmark_alt,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.registrationSuccessTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.registrationSuccessText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.registrationClose),
        ),
      ],
    );
  }
}
