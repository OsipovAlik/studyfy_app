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

/// A bottom-bar tab: its label, Material icons, iOS SF Symbol, and which
/// [StatefulShellRoute] branch it opens (branches are fixed once the
/// router is built, so hiding a tab for one role never changes these
/// indices — see [MainShell._visibleTabs]).
class _Tab {
  const _Tab({
    required this.branchIndex,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.sfSymbol,
  });

  final int branchIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String sfSymbol;
}

/// The signed-in frame: the tabs and the bottom bar.
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

  /// Every branch the router defines, in router order. [_visibleTabs]
  /// filters this down for the bar; the branch indices here must always
  /// match `createRouter`'s `StatefulShellRoute.indexedStack` branches.
  List<_Tab> _allTabs(AppLocalizations l10n, UserRole? role) => [
    _Tab(
      branchIndex: 0,
      label: l10n.tabHome,
      icon: CupertinoIcons.house,
      selectedIcon: CupertinoIcons.house_fill,
      sfSymbol: 'house.fill',
    ),
    _Tab(
      branchIndex: 1,
      label: l10n.tabSubjects,
      icon: CupertinoIcons.book,
      selectedIcon: CupertinoIcons.book_fill,
      sfSymbol: 'books.vertical.fill',
    ),
    _Tab(
      branchIndex: 2,
      label: l10n.tabSessions,
      icon: CupertinoIcons.calendar,
      selectedIcon: CupertinoIcons.calendar,
      sfSymbol: 'calendar',
    ),
    _Tab(
      branchIndex: 3,
      label: l10n.tabStudents,
      icon: CupertinoIcons.person_3,
      selectedIcon: CupertinoIcons.person_3_fill,
      sfSymbol: 'person.3.fill',
    ),
    _Tab(
      branchIndex: 4,
      // Teachers manage everyone's homework; students see their own.
      label: role == UserRole.teacher ? l10n.tabHomework : l10n.tabMyHomework,
      icon: CupertinoIcons.doc_text,
      selectedIcon: CupertinoIcons.doc_text_fill,
      sfSymbol: 'checklist',
    ),
    _Tab(
      branchIndex: 5,
      label: l10n.tabProfile,
      icon: CupertinoIcons.person,
      selectedIcon: CupertinoIcons.person_fill,
      sfSymbol: 'person.crop.circle.fill',
    ),
  ];

  /// The tabs actually shown in the bar: Students only for teachers.
  List<_Tab> _visibleTabs(AppLocalizations l10n, UserRole? role) => [
    for (final tab in _allTabs(l10n, role))
      if (tab.branchIndex != 3 || role == UserRole.teacher) tab,
  ];

  void _select(List<_Tab> tabs, int position) {
    final branchIndex = tabs[position].branchIndex;
    navigationShell.goBranch(
      branchIndex,
      // Tapping the current tab again returns to its first page.
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = context.select<AuthController, UserRole?>(
      (auth) => auth.user?.role,
    );
    final tabs = _visibleTabs(l10n, role);
    // This is normally found (a student can never land on the Students
    // branch; see [AppRoutes] and `createRouter`'s redirect). It can
    // briefly miss for one frame right as a role changes, just before
    // the redirect catches up; fall back to the first tab rather than
    // hand a bar widget an index it doesn't have.
    final rawSelectedPosition = tabs.indexWhere(
      (tab) => tab.branchIndex == navigationShell.currentIndex,
    );
    final selectedPosition = rawSelectedPosition < 0 ? 0 : rawSelectedPosition;
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
          currentIndex: selectedPosition,
          tint: Theme.of(context).colorScheme.primary,
          onTap: (position) => _select(tabs, position),
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
        selectedIndex: selectedPosition,
        onSelected: (position) => _select(tabs, position),
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
