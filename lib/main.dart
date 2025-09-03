import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:magus/core/home.dart';
import 'package:magus/features/ai/ai.dart';
import 'package:magus/features/authentication/authentication.dart';
import 'package:magus/features/graphs/graphs.dart';
import 'package:magus/features/reminders/reminders.dart';
import 'package:magus/features/routine_management/routine_management.dart';
import 'package:magus/features/routine_tracking/routine_tracking.dart';
import 'package:magus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String home = '/';
  static const String ai = '/ai';
  static const String graphs = '/graphs';
  static const String reminders = '/reminders';
  static const String routineManagement = '/routine_management';
  static const String routineTracking = '/routine_tracking';
  static const String auth = '/auth';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: auth, // Start with authentication
      routes: {
        home: (context) => const HomePage(),
        ai: (context) => const AIPage(),
        graphs: (context) => const GraphsPage(),
        reminders: (context) => const RemindersPage(),
        routineManagement: (context) => const RoutineManagementPage(),
        routineTracking: (context) => const RoutineTrackingPage(),
        auth: (context) => const AuthRoute(), // Entry checkpoint
      },
    );
  }
}
