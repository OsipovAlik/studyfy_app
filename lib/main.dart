import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/app.dart';
import 'package:studify/core/storage/app_preferences.dart';
import 'package:studify/features/auth/data/session_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppDependencies.create(
    preferences: AppPreferences(await SharedPreferences.getInstance()),
    sessionStorage: SessionStorage(),
  );

  runApp(StudyfyApp(dependencies: dependencies));

  unawaited(dependencies.auth.refreshProfile());
}
