import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/auth_page.dart';
// import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_application_1/pages/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 
          const Text('FRUIT VIS', 
          style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
          duration: 2000,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white
      , 
      nextScreen: const AuthPage()
      )
    );
  }
}
