import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
import 'package:studify/features/contact/contact_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Sign in with email and password (`POST /login`).
///
/// On success the router moves on to the home screen by itself, because
/// [AuthController] reports the new session.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _remember = true;
  bool _busy = false;
  _Message? _message;

  /// Set while the API refuses attempts (`429`).
  DateTime? _lockedUntil;
  Timer? _lockTimer;

  @override
  void initState() {
    super.initState();
    final pending = context.read<AuthController>().takeNotice();
    if (pending != null) {
      _message = _Message.fromNotice(pending.notice);
      _email.text = pending.email ?? '';
    }
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  int get _secondsLeft {
    final until = _lockedUntil;
    if (until == null) return 0;
    final ms = until.difference(clock.now()).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  bool get _isLocked => _secondsLeft > 0;

  Future<void> _submit() async {
    if (_busy || _isLocked) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await context.read<AuthController>().signIn(
        email: _email.text.trim(),
        password: _password.text,
        remember: _remember,
      );
      // Let the system offer to save the password.
      TextInput.finishAutofillContext();
    } on TooManyAttempts catch (failure) {
      _startLockout(failure.retryAfter);
    } on SignInFailure catch (failure) {
      if (mounted) setState(() => _message = _Message.fromFailure(failure));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startLockout(Duration retryAfter) {
    if (!mounted) return;
    _lockTimer?.cancel();
    setState(() => _lockedUntil = clock.now().add(retryAfter));
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (!_isLocked) {
          timer.cancel();
          _lockedUntil = null;
        }
      });
    });
  }

  /// Opens the reset screen; it returns the email after a successful
  /// reset, so this screen can confirm it and fill the address in.
  Future<void> _openForgotPassword() async {
    final email = _email.text.trim();
    final resetEmail = await context.push<String>(
      Uri(
        path: AppRoutes.forgotPassword,
        queryParameters: AuthValidators.isEmail(email)
            ? {'email': email}
            : null,
      ).toString(),
    );
    if (resetEmail == null || !mounted) return;
    _lockTimer?.cancel();
    setState(() {
      // A reset also unlocks the account.
      _lockedUntil = null;
      _message = _Message.fromNotice(AuthNotice.passwordReset);
      _email.text = resetEmail;
      _password.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final locked = _isLocked;

    return AuthScaffold(
      children: [
        Text(
          l10n.loginWelcome,
          style: theme.textTheme.titleMedium?.copyWith(color: muted),
        ),
        const SizedBox(height: 4),
        _RotatingWord(
          words: [
            l10n.loginWordLearn,
            l10n.loginWordDiscover,
            l10n.loginWordGrow,
            l10n.loginWordAchieve,
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.loginSubtitle,
          style: theme.textTheme.bodyLarge?.copyWith(color: muted),
        ),
        const SizedBox(height: 24),
        AuthCard(
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _email,
                    enabled: !_busy,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.username,
                    ],
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: l10n.loginEmail,
                      hintText: 'you@example.com',
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (value) => AuthValidators.isEmail(value ?? '')
                        ? null
                        : l10n.registrationInvalidEmail,
                  ),
                  const SizedBox(height: 14),
                  PasswordField(
                    controller: _password,
                    enabled: !_busy,
                    label: l10n.loginPassword,
                    autofillHints: const [AutofillHints.password],
                    onSubmitted: (_) => _submit(),
                    validator: (value) => (value ?? '').isEmpty
                        ? l10n.loginPasswordRequired
                        : null,
                  ),
                  // Its own line: "Forgot?" is long in some languages
                  // ("Забыли пароль?") and would squeeze the checkbox label.
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: _busy
                          ? null
                          : () => unawaited(_openForgotPassword()),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(l10n.loginForgot),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _busy
                        ? null
                        : () => setState(() => _remember = !_remember),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          onChanged: _busy
                              ? null
                              : (value) =>
                                    setState(() => _remember = value ?? false),
                        ),
                        Expanded(
                          child: Text(
                            l10n.loginRemember,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (locked) ...[
                    const SizedBox(height: 10),
                    NoticeBanner(
                      tone: NoticeTone.warning,
                      message: l10n.loginTooMany,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          l10n.loginRetryIn(formatCountdown(_secondsLeft)),
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => unawaited(_openForgotPassword()),
                          child: Text(
                            l10n.loginResetPassword,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.loginResetUnlocks,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ] else if (_message != null) ...[
                    const SizedBox(height: 10),
                    NoticeBanner(
                      tone: _message!.tone,
                      message: _message!.text(l10n),
                    ),
                  ],
                  const SizedBox(height: 16),
                  BusyButton(
                    label: locked
                        ? l10n.loginRetryIn(formatCountdown(_secondsLeft))
                        : l10n.loginSignIn,
                    busyLabel: l10n.loginSigningIn,
                    busy: _busy,
                    onPressed: locked ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _busy ? null : () => showContactSheet(context),
            child: Text(l10n.loginNewSchool, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}

/// A message shown under the form.
class _Message {
  const _Message(this.tone, this.text);

  factory _Message.fromNotice(AuthNotice notice) => switch (notice) {
    AuthNotice.passwordReset => _Message(
      NoticeTone.success,
      (l10n) => l10n.loginResetSuccess,
    ),
    AuthNotice.sessionExpired => _Message(
      NoticeTone.info,
      (l10n) => l10n.loginSessionExpired,
    ),
    AuthNotice.schoolInactive => _Message(
      NoticeTone.error,
      (l10n) => l10n.loginInactive,
    ),
  };

  factory _Message.fromFailure(SignInFailure failure) => switch (failure) {
    InvalidCredentials() => _Message(
      NoticeTone.error,
      (l10n) => l10n.loginInvalid,
    ),
    SchoolInactive() => _Message(
      NoticeTone.error,
      (l10n) => l10n.loginInactive,
    ),
    AdminNotSupported() => _Message(
      NoticeTone.error,
      (l10n) => l10n.loginAdminNotSupported,
    ),
    ServiceUnavailable() => _Message(
      NoticeTone.error,
      (l10n) => l10n.loginUnavailable,
    ),
    TooManyAttempts() => _Message(
      NoticeTone.warning,
      (l10n) => l10n.loginTooMany,
    ),
  };

  final NoticeTone tone;

  /// Built at display time so it follows a language change.
  final String Function(AppLocalizations l10n) text;
}

/// "Learn. / Discover. / Grow. / Achieve." in the brand gradient, cycling
/// as on the website's login page.
class _RotatingWord extends StatefulWidget {
  const _RotatingWord({required this.words});

  final List<String> words;

  @override
  State<_RotatingWord> createState() => _RotatingWordState();
}

class _RotatingWordState extends State<_RotatingWord> {
  late final Timer _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2400), (_) {
      setState(() => _index = (_index + 1) % widget.words.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displaySmall;
    final word = widget.words[_index % widget.words.length];

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (current, previous) => Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [...previous, ?current],
        ),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: ShaderMask(
          key: ValueKey(word),
          blendMode: BlendMode.srcIn,
          shaderCallback: AppColors.brandGradient.createShader,
          child: Text('$word.', style: style),
        ),
      ),
    );
  }
}
