import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/app.dart';
import 'package:studify/core/storage/app_preferences.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dependencies = await AppDependencies.create(
    preferences: AppPreferences(await SharedPreferences.getInstance()),
    sessionStorage: SessionStorage(),
  );

  runApp(StudyfyApp(dependencies: dependencies));

  unawaited(dependencies.auth.refreshProfile());

  // Push notifications only make sense once someone's signed in — covers
  // both a restored session (checked once, here) and a fresh login
  // (the listener below). activate() re-registers the device token on
  // every call, so both call sites matter, not just the first.
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
