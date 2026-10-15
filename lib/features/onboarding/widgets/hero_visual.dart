import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';

/// The logo illustration with the website's subject emojis floating
/// around it.
class HeroVisual extends StatefulWidget {
  const HeroVisual({super.key});

  @override
  State<HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<HeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  static const List<({String emoji, Alignment alignment, double phase})>
  _bubbles = [
    (emoji: '📚', alignment: Alignment(-0.95, -0.85), phase: 0.0),
    (emoji: '✏️', alignment: Alignment(0.92, -0.95), phase: 0.6),
    (emoji: '🧠', alignment: Alignment(-1.05, 0.15), phase: 1.4),
    (emoji: '🌍', alignment: Alignment(1.05, 0.05), phase: 2.1),
    (emoji: '🎓', alignment: Alignment(-0.8, 0.98), phase: 2.9),
    (emoji: '💡', alignment: Alignment(0.82, 0.95), phase: 3.6),
  ];

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 250,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow behind the card.
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.indigo500.withValues(alpha: 0.28),
                  AppColors.indigo500.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          // The logo has a white background, so it sits on a white card
          // in both light and dark mode.
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                BoxShadow(
                  color: AppColors.indigo600.withValues(alpha: 0.22),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(38),
              child: Image.asset(
                'assets/images/studyfy_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          for (final bubble in _bubbles)
            Align(
              alignment: bubble.alignment,
              child: AnimatedBuilder(
                animation: _float,
                builder: (context, child) {
                  final t = _float.value * 2 * math.pi + bubble.phase;
                  return Transform.translate(
                    offset: Offset(0, math.sin(t) * 6),
                    child: child,
                  );
                },
                child: _EmojiBubble(
                  emoji: bubble.emoji,
                  background: scheme.surfaceContainerLowest,
                  border: scheme.outlineVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmojiBubble extends StatelessWidget {
  const _EmojiBubble({
    required this.emoji,
    required this.background,
    required this.border,
  });

  final String emoji;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 22)),
    );
  }
}

/// "Everything your school needs to teach / schedule / test / grow",
/// with the last word cycling like on the website.
class RotatingHeadline extends StatefulWidget {
  const RotatingHeadline({
    required this.lead,
    required this.words,
    required this.suffix,
    super.key,
  });

  final String lead;
  final List<String> words;
  final String suffix;

  @override
  State<RotatingHeadline> createState() => _RotatingHeadlineState();
}

class _RotatingHeadlineState extends State<RotatingHeadline> {
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
    final style = Theme.of(context).textTheme.headlineMedium;
    final word = widget.words[_index % widget.words.length];

    return Column(
      children: [
        Text(widget.lead, textAlign: TextAlign.center, style: style),
        const SizedBox(height: 2),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
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
                child: Text(word, style: style),
              ),
            ),
            if (widget.suffix.isNotEmpty) Text(widget.suffix, style: style),
          ],
        ),
      ],
    );
  }
}

/// "Built for language schools" pill above the headline.
class HeroBadge extends StatelessWidget {
  const HeroBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.sparkles, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
