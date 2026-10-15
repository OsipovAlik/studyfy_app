import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Password reset in two steps, as on the website:
/// 1. `POST /password/forgot` emails a 6-digit code;
/// 2. `POST /password/reset` sets the new password with that code.
///
/// A reset also unlocks an account locked by too many wrong passwords.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({this.initialEmail, super.key});

  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum _Step { email, code }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// Wait before another code can be requested.
  static const _resendCooldown = 60;

  /// Lockout assumed when a `429` comes without `Retry-After` (15 min).
  static const _defaultLockout = Duration(minutes: 15);

  final _emailForm = GlobalKey<FormState>();
  final _resetForm = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail ?? '');
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  _Step _step = _Step.email;
  bool _busy = false;
  bool _resending = false;
  String Function(AppLocalizations)? _error;
  String Function(AppLocalizations)? _info;

  int _cooldown = 0;
  Timer? _cooldownTimer;

  /// The address the code was sent to.
  String _sentTo = '';

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  AuthRepository get _repository => context.read<AuthRepository>();

  Future<void> _sendCode() async {
    FocusScope.of(context).unfocus();
    if (!_emailForm.currentState!.validate()) return;

    final email = _email.text.trim();
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    try {
      await _repository.requestPasswordReset(email);
      if (!mounted) return;
      setState(() {
        _sentTo = email;
        _step = _Step.code;
      });
      _startCooldown();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = _requestError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resendCode() async {
    if (_cooldown > 0 || _resending || _busy) return;
    setState(() {
      _resending = true;
      _error = null;
      _info = null;
    });
    try {
      await _repository.requestPasswordReset(_sentTo);
      if (!mounted) return;
      setState(() => _info = (l10n) => l10n.forgotResendSent);
      _startCooldown();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = _requestError(error));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _info = null;
    });
    if (!_resetForm.currentState!.validate()) return;

    setState(() => _busy = true);
    try {
      await _repository.resetPassword(
        email: _sentTo,
        code: _code.text,
        password: _password.text,
      );
      if (!mounted) return;
      if (context.canPop()) {
        // Back to the login screen underneath, which shows the message.
        context.pop(_sentTo);
      } else {
        context.read<AuthController>().setNotice(
          AuthNotice.passwordReset,
          email: _sentTo,
        );
        context.go(AppRoutes.login);
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error) {
          _ when error.isTooManyRequests => _tooMany(error),
          _ when error.isNetworkError => (l10n) => l10n.errorServerUnavailable,
          // A wrong, expired or used code: the form checked everything else.
          _ when error.isValidation => (l10n) => l10n.forgotCodeIncorrect,
          _ => (l10n) => l10n.errorGeneric,
        };
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String Function(AppLocalizations) _requestError(ApiException error) {
    if (error.isTooManyRequests) return _tooMany(error);
    if (error.isNetworkError) return (l10n) => l10n.errorServerUnavailable;
    if (error.isValidation) return (l10n) => l10n.registrationInvalidEmail;
    return (l10n) => l10n.errorGeneric;
  }

  String Function(AppLocalizations) _tooMany(ApiException error) {
    final seconds = (error.retryAfter ?? _defaultLockout).inSeconds;
    final minutes = (seconds / 60).ceil().clamp(1, 1 << 30);
    return (l10n) => l10n.forgotTooMany(minutes);
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = _resendCooldown);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _cooldown--);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  void _changeEmail() {
    _cooldownTimer?.cancel();
    setState(() {
      _step = _Step.email;
      _cooldown = 0;
      _error = null;
      _info = null;
      _code.clear();
      _password.clear();
      _confirm.clear();
    });
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final isEmailStep = _step == _Step.email;

    return AuthScaffold(
      onBack: _busy ? null : _backToLogin,
      children: [
        Text(
          isEmailStep ? l10n.forgotTitle : l10n.forgotStep2Title,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          isEmailStep ? l10n.forgotSubtitle : l10n.forgotStep2Subtitle(_sentTo),
          style: theme.textTheme.bodyLarge?.copyWith(color: muted),
        ),
        const SizedBox(height: 24),
        AuthCard(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isEmailStep
                ? _buildEmailStep(l10n)
                : _buildCodeStep(l10n, theme),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: _busy ? null : _backToLogin,
            icon: const Icon(CupertinoIcons.back, size: 18),
            label: Text(l10n.forgotBackToLogin),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStep(AppLocalizations l10n) {
    return Form(
      key: _emailForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _email,
            enabled: !_busy,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            enableSuggestions: false,
            onFieldSubmitted: (_) => _sendCode(),
            decoration: InputDecoration(
              labelText: l10n.forgotEmailLabel,
              hintText: 'you@example.com',
              prefixIcon: const Icon(CupertinoIcons.mail),
            ),
            validator: (value) => AuthValidators.isEmail(value ?? '')
                ? null
                : l10n.registrationInvalidEmail,
          ),
          ..._messages(l10n),
          const SizedBox(height: 16),
          BusyButton(
            label: l10n.forgotSubmit,
            busyLabel: l10n.forgotSending,
            busy: _busy,
            onPressed: _sendCode,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep(AppLocalizations l10n, ThemeData theme) {
    return AutofillGroup(
      child: Form(
        key: _resetForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _code,
              enabled: !_busy,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 6),
              decoration: InputDecoration(
                labelText: l10n.forgotCodeLabel,
                hintText: l10n.forgotCodePlaceholder,
                prefixIcon: const Icon(CupertinoIcons.number),
              ),
              validator: (value) => AuthValidators.isResetCode(value ?? '')
                  ? null
                  : l10n.forgotCodeInvalid,
            ),
            const SizedBox(height: 14),
            PasswordField(
              controller: _password,
              enabled: !_busy,
              label: l10n.forgotPasswordLabel,
              helperText: l10n.forgotPasswordRule,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              validator: (value) => AuthValidators.isPassword(value ?? '')
                  ? null
                  : l10n.forgotPasswordRule,
            ),
            const SizedBox(height: 14),
            PasswordField(
              controller: _confirm,
              enabled: !_busy,
              label: l10n.forgotConfirmLabel,
              autofillHints: const [AutofillHints.newPassword],
              onSubmitted: (_) => _resetPassword(),
              validator: (value) =>
                  value == _password.text ? null : l10n.forgotMismatch,
            ),
            ..._messages(l10n),
            const SizedBox(height: 16),
            BusyButton(
              label: l10n.forgotSubmitReset,
              busyLabel: l10n.forgotResetting,
              busy: _busy,
              onPressed: _resetPassword,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  onPressed: _cooldown > 0 || _resending || _busy
                      ? null
                      : _resendCode,
                  child: Text(
                    _cooldown > 0
                        ? l10n.forgotResendCodeIn(_cooldown)
                        : l10n.forgotResendCode,
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : _changeEmail,
                  child: Text(l10n.forgotChangeEmail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _messages(AppLocalizations l10n) => [
    if (_error != null) ...[
      const SizedBox(height: 14),
      NoticeBanner(tone: NoticeTone.error, message: _error!(l10n)),
    ] else if (_info != null) ...[
      const SizedBox(height: 14),
      NoticeBanner(tone: NoticeTone.success, message: _info!(l10n)),
    ],
  ];
}
