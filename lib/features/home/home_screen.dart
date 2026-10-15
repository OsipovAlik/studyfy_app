import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/home/widgets/welcome_banner.dart';

/// The Home tab: the welcome banner, for now.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [WelcomeBanner(user: user)],
            ),
          ),
        ],
      ),
    );
  }
}
