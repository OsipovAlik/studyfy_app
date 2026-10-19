import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';

/// Page frame for a screen opened from a tab: a fixed back button, then
/// a large title and scrolling content, on the brand glow. Pass
/// [onRefresh] to let the content be pulled to refresh.
class SubPage extends StatelessWidget {
  const SubPage({
    required this.title,
    required this.children,
    this.onRefresh,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Text(title, style: theme.textTheme.headlineLarge),
        const SizedBox(height: 24),
        ...children,
      ],
    );
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stays put while the content scrolls.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    icon: const Icon(CupertinoIcons.back),
                  ),
                ),
                Expanded(
                  child: onRefresh == null
                      ? list
                      : RefreshIndicator(onRefresh: onRefresh!, child: list),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
