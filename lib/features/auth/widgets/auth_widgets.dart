import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/core/widgets/language_button.dart';
import 'package:studify/core/widgets/studyfy_logo.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Validation rules shared by the account forms, matching the API.
abstract final class AuthValidators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// 8–32 characters: letters, digits and `!@#$%^&*` only.
  static final _password = RegExp(r'^[a-zA-Z0-9!@#$%^&*]{8,32}$');

  static final _code = RegExp(r'^\d{6}$');

  static bool isEmail(String value) => _email.hasMatch(value.trim());
  static bool isPassword(String value) => _password.hasMatch(value);
  static bool isResetCode(String value) => _code.hasMatch(value);
}

/// "m:ss", or "h:mm:ss" from an hour up, as on the website.
String formatCountdown(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return hours > 0
      ? '$hours:${two(minutes)}:${two(seconds)}'
      : '$minutes:${two(seconds)}';
}

/// Page frame for the signed-out screens: brand glow, logo, language
/// switcher and a centered, scrollable column.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.children, this.onBack, super.key});

  final List<Widget> children;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
                  child: Row(
                    children: [
                      if (onBack != null)
                        IconButton(
                          onPressed: onBack,
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          icon: const Icon(CupertinoIcons.back),
                        )
                      else
                        const SizedBox(width: 8),
                      const Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: StudyfyLogo(markSize: 28),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const LanguageButton(),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: children,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White card holding a form.
class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo500.withValues(alpha: isDark ? 0.12 : 0.1),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Password input with a show / hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.label,
    this.enabled = true,
    this.autofillHints,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.validator,
    this.helperText,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? helperText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        helperMaxLines: 2,
        prefixIcon: const Icon(CupertinoIcons.lock),
        suffixIcon: IconButton(
          tooltip: _obscured ? l10n.passwordShow : l10n.passwordHide,
          onPressed: () => setState(() => _obscured = !_obscured),
          icon: Icon(
            _obscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          ),
        ),
      ),
    );
  }
}

enum NoticeTone { success, error, warning, info }

/// A coloured message box under a form.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({
    required this.tone,
    required this.message,
    this.children = const [],
    super.key,
  });

  final NoticeTone tone;
  final String message;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (Color color, IconData icon) = switch (tone) {
      NoticeTone.success => (
        AppColors.emerald500,
        CupertinoIcons.checkmark_circle_fill,
      ),
      NoticeTone.error => (scheme.error, CupertinoIcons.exclamationmark_circle),
      NoticeTone.warning => (AppColors.amber500, CupertinoIcons.clock),
      NoticeTone.info => (scheme.primary, CupertinoIcons.info_circle),
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  ...children,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A primary button that shows a spinner and a label while busy.
class BusyButton extends StatelessWidget {
  const BusyButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.busyLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final String? busyLabel;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(busyLabel ?? label, overflow: TextOverflow.fade),
                ),
              ],
            )
          : Text(label),
    );
  }
}
