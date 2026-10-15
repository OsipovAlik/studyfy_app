import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/l10n/app_localizations.dart';

/// "Welcome back, Name 👋" over the Paris skyline, with the school's name.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({required this.user, super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : AppColors.indigo950;
    final muted = isDark ? Colors.white.withValues(alpha: 0.82) : AppColors.stone700;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.indigo200,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                isDark ? 'assets/svg/banner-default-dark.svg' : 'assets/svg/banner-default-light.svg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 160),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.paperplane,
                          size: 28,
                          color: isDark ? AppColors.indigo300 : AppColors.indigo600,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${l10n.homeWelcome(user.name)} 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(color: muted),
                    ),
                    if (user.partnerName.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _SchoolChip(
                        name: user.partnerName,
                        isDark: isDark,
                        color: foreground,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchoolChip extends StatelessWidget {
  const _SchoolChip({
    required this.name,
    required this.isDark,
    required this.color,
  });

  final String name;
  final bool isDark;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.indigo200,
        ),
      ),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
