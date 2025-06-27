import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:palm_code_challenge/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());

  // Setup dependency injection
  await setupDependencies();

  runApp(const PalmCodeChallengeApp());
}
