import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/core/widgets/language_button.dart';
import 'package:studify/core/widgets/studyfy_logo.dart';
import 'package:studify/features/contact/contact_sheet.dart';
import 'package:studify/features/onboarding/widgets/hero_visual.dart';
import 'package:studify/features/onboarding/widgets/mock_visuals.dart';
import 'package:studify/features/onboarding/widgets/onboarding_slide.dart';
import 'package:studify/l10n/app_localizations.dart';

/// First-run introduction, built from the Studyfy landing page.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageCount = 4;
  static const _pageDuration = Duration(milliseconds: 450);

  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) => unawaited(
    _controller.animateToPage(
      page,
      duration: _pageDuration,
      curve: Curves.easeOutCubic,
    ),
  );

  void _signIn() => context.go(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  showSkip: !_isLast,
                  onSkip: () => _goTo(_pageCount - 1),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (page) => setState(() => _page = page),
                    children: [
                      OnboardingSlide(
                        visual: const HeroVisual(),
                        header: HeroBadge(l10n.landingBadge),
                        title: RotatingHeadline(
                          lead: l10n.landingHeroLead,
                          words: [
                            l10n.landingHeroWordTeach,
                            l10n.landingHeroWordSchedule,
                            l10n.landingHeroWordTest,
                            l10n.landingHeroWordGrow,
                          ],
                          suffix: l10n.landingHeroWordSuffix,
                        ),
                        body: SlideBody(l10n.landingHeroSub),
                      ),
                      OnboardingSlide(
                        visual: const TestResultMock(),
                        title: SlideTitle(l10n.landingFeatureTestsTitle),
                        body: SlideBody(l10n.landingFeatureTestsDesc),
                        footer: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            InfoChip(
                              icon: CupertinoIcons.photo_on_rectangle,
                              label: l10n.landingChipTests,
                            ),
                            InfoChip(
                              icon: CupertinoIcons.bolt_fill,
                              label: l10n.landingChipGrading,
                            ),
                          ],
                        ),
                      ),
                      OnboardingSlide(
                        visual: const TimetableMock(),
                        title: SlideTitle(l10n.landingFeatureTimetableTitle),
                        body: SlideBody(l10n.landingFeatureTimetableDesc),
                        footer: InfoChip(
                          icon: CupertinoIcons.repeat,
                          label: l10n.landingChipSessions,
                        ),
                      ),
                      OnboardingSlide(
                        visual: const RolesMock(),
                        title: SlideTitle(l10n.landingRolesTitle),
                        body: SlideBody(l10n.landingCtaSub),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      layoutBuilder: (current, previous) => Stack(
                        alignment: Alignment.bottomCenter,
                        children: [...previous, ?current],
                      ),
                      child: _isLast
                          ? _FinalActions(
                              onSignIn: _signIn,
                              onRegister: () => showContactSheet(context),
                            )
                          : _NextRow(
                              page: _page,
                              count: _pageCount,
                              onNext: () => _goTo(_page + 1),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.showSkip, required this.onSkip});

  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: StudyfyLogo(markSize: 28),
            ),
          ),
          const SizedBox(width: 8),
          const LanguageButton(),
          if (showSkip)
            AnimatedOpacity(
              opacity: showSkip ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !showSkip,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(AppLocalizations.of(context).onboardingSkip),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NextRow extends StatelessWidget {
  const _NextRow({
    required this.page,
    required this.count,
    required this.onNext,
  });

  final int page;
  final int count;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageDots(page: page, count: count),
        const Spacer(),
        FilledButton(
          onPressed: onNext,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).onboardingNext),
              const SizedBox(width: 8),
              const Icon(CupertinoIcons.arrow_right, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinalActions extends StatelessWidget {
  const _FinalActions({required this.onSignIn, required this.onRegister});

  final VoidCallback onSignIn;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(onPressed: onSignIn, child: Text(l10n.signIn)),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onRegister,
          child: Text(l10n.registrationButton),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.page, required this.count});

  final int page;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsetsDirectional.only(end: 6),
            width: i == page ? 26 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == page ? scheme.primary : scheme.outline,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
