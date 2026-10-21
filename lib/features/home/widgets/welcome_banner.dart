import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/home/home_banner_controller.dart';
import 'package:studify/features/home/widgets/banner_picture_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

/// "Welcome back, Name 👋" over the Paris skyline (or, once a teacher
/// sets one, a subject's own picture), with the school's name.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({required this.user, super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : AppColors.indigo950;
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : AppColors.stone700;
    final bannerController = context.watch<HomeBannerController>();
    final imageUrl = bannerController.bannerImageUrl;
    final background = theme.colorScheme.surface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.indigo200,
          ),
        ),
        child: Stack(
          children: [
            if (imageUrl != null) ...[
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
              // Keeps the picture's right side visible while the text
              // on the left stays readable.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [background, background.withValues(alpha: 0)],
                      stops: const [0.15, 0.65],
                    ),
                  ),
                ),
              ),
            ] else ...[
              Positioned.fill(
                child: SvgPicture.asset(
                  isDark
                      ? 'assets/svg/banner-default-dark.svg'
                      : 'assets/svg/banner-default-light.svg',
                  fit: BoxFit.cover,
                ),
              ),
              // Fills the whole banner, however tall the text makes it.
              Positioned.fill(
                child: ColoredBox(
                  color: isDark
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 160),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.paperplane,
                          size: 22,
                          color: isDark
                              ? AppColors.indigo300
                              : AppColors.indigo600,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${l10n.homeWelcome(user.name)} 👋',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: foreground,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: muted,
                        fontSize: 14,
                      ),
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
            // Last so it's checked first by hit-testing — otherwise the
            // welcome text's Expanded Text, which claims taps anywhere
            // in its laid-out box even past the visible glyphs, would
            // swallow taps meant for this button.
            if (bannerController.isTeacher)
              Positioned(
                top: 10,
                right: 10,
                child: _EditButton(
                  isDark: isDark,
                  onTap: () => showBannerPictureSheet(
                    context,
                    controller: bannerController,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark
          ? Colors.black.withValues(alpha: 0.35)
          : Colors.white.withValues(alpha: 0.75),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            CupertinoIcons.camera,
            size: 16,
            color: isDark ? Colors.white : AppColors.indigo950,
          ),
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
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.14)
              : AppColors.indigo200,
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
