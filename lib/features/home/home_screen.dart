import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/home/home_banner_controller.dart';
import 'package:studify/features/home/home_stats_controller.dart';
import 'package:studify/features/home/weekly_activity_controller.dart';
import 'package:studify/features/home/widgets/home_stats_grid.dart';
import 'package:studify/features/home/widgets/weekly_activity_card.dart';
import 'package:studify/features/home/widgets/weekly_timetable_card.dart';
import 'package:studify/features/home/widgets/welcome_banner.dart';
import 'package:studify/features/sessions/timetable_controller.dart';

/// The Home tab: the welcome banner and this week's timetable.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<TimetableController>().ensureLoaded());
    unawaited(context.read<HomeStatsController>().ensureLoaded());
    unawaited(context.read<WeeklyActivityController>().ensureLoaded());
    unawaited(context.read<HomeBannerController>().ensureLoaded());
  }

  Future<void> _refresh() => Future.wait([
    context.read<TimetableController>().reload(),
    context.read<HomeStatsController>().reload(),
    context.read<WeeklyActivityController>().reload(),
    context.read<HomeBannerController>().reload(),
  ]);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    if (user == null) return const Scaffold();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          // The bottom safe area includes the floating tab bar.
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  WelcomeBanner(user: user),
                  const SizedBox(height: 16),
                  const HomeStatsGrid(),
                  const WeeklyTimetableCard(),
                  const SizedBox(height: 16),
                  const WeeklyActivityCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
