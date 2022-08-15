import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/forum_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ForumScreen.id: (context) => const ForumScreen(),
      },
    );
  }
}
