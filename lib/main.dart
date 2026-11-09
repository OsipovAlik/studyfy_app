import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/app.dart';
import 'package:studify/core/storage/app_preferences.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dependencies = await AppDependencies.create(
    preferences: AppPreferences(await SharedPreferences.getInstance()),
    sessionStorage: SessionStorage(),
  );

  runApp(
    LiquidGlassWidgets.wrap(
      brightnessResolver: Theme.maybeBrightnessOf,
      child: StudyfyApp(dependencies: dependencies),
    ),
  );

  unawaited(dependencies.auth.refreshProfile());

  final pushNotifications = dependencies.pushNotifications;
  if (dependencies.auth.isSignedIn) {
    unawaited(pushNotifications.activate());
  }
  dependencies.auth.addListener(() {
    if (dependencies.auth.isSignedIn) {
      unawaited(pushNotifications.activate());
    }
  });
}
