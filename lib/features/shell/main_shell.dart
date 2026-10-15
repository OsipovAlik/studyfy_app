import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/shell/glass_nav_bar.dart';
import 'package:studify/l10n/app_localizations.dart';

/// A bottom-bar tab: its label, Material icons and iOS SF Symbol.
class _Tab {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.sfSymbol,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String sfSymbol;
}

/// The signed-in frame: the five tabs and the bottom bar.
///
/// iOS shows the native Liquid Glass tab bar (`cupertino_native`); other
/// platforms show [GlassNavBar], drawn in Flutter to match it. Both float
/// over the page, so the pages get the bar's height as bottom padding.
class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Height of the native bar when it has not reported its own yet.
  static const _nativeBarHeight = 50.0;

  static bool get _useNativeBar => defaultTargetPlatform == TargetPlatform.iOS;

  List<_Tab> _tabs(AppLocalizations l10n, UserRole? role) => [
    _Tab(
      label: l10n.tabHome,
      icon: CupertinoIcons.house,
      selectedIcon: CupertinoIcons.house_fill,
      sfSymbol: 'house.fill',
    ),
    _Tab(
      label: l10n.tabSubjects,
      icon: CupertinoIcons.book,
      selectedIcon: CupertinoIcons.book_fill,
      sfSymbol: 'books.vertical.fill',
    ),
    _Tab(
      label: l10n.tabSessions,
      icon: CupertinoIcons.calendar,
      selectedIcon: CupertinoIcons.calendar,
      sfSymbol: 'calendar',
    ),
    _Tab(
      // Teachers manage everyone's homework; students see their own.
      label: role == UserRole.teacher ? l10n.tabHomework : l10n.tabMyHomework,
      icon: CupertinoIcons.doc_text,
      selectedIcon: CupertinoIcons.doc_text_fill,
      sfSymbol: 'checklist',
    ),
    _Tab(
      label: l10n.tabProfile,
      icon: CupertinoIcons.person,
      selectedIcon: CupertinoIcons.person_fill,
      sfSymbol: 'person.crop.circle.fill',
    ),
  ];

  void _select(int index) => navigationShell.goBranch(
    index,
    // Tapping the current tab again returns to its first page.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = context.select<AuthController, UserRole?>(
      (auth) => auth.user?.role,
    );
    final tabs = _tabs(l10n, role);
    final media = MediaQuery.of(context);

    final Widget bar;
    final double barSpace;
    if (_useNativeBar) {
      bar = SafeArea(
        top: false,
        child: CNTabBar(
          items: [
            for (final tab in tabs)
              CNTabBarItem(label: tab.label, icon: CNSymbol(tab.sfSymbol)),
          ],
          currentIndex: navigationShell.currentIndex,
          tint: Theme.of(context).colorScheme.primary,
          onTap: _select,
        ),
      );
      barSpace = _nativeBarHeight + 8;
    } else {
      bar = GlassNavBar(
        destinations: [
          for (final tab in tabs)
            GlassNavDestination(
              label: tab.label,
              icon: tab.icon,
              selectedIcon: tab.selectedIcon,
            ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onSelected: _select,
      );
      barSpace = GlassNavBar.barHeight + GlassNavBar.bottomGap + 8;
    }

    return Scaffold(
      // The keyboard covers the bar instead of pushing it up.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: MediaQuery(
              // Pages see the bar as part of the bottom safe area, so
              // SafeArea and scroll views keep content clear of it.
              data: media.copyWith(
                padding: media.padding.copyWith(
                  bottom: media.padding.bottom + barSpace,
                ),
              ),
              child: navigationShell,
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: bar),
        ],
      ),
    );
  }
}
