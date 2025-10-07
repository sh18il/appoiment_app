import 'package:appoiment_app/controller/auth/login_controller.dart';
import 'package:appoiment_app/controller/pationt_controller.dart';
import 'package:appoiment_app/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => PationtController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: const SplashScreen(),
      ),
    );
  }
}
