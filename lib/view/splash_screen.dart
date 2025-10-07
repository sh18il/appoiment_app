import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/view/auth/login_screen.dart';
import 'package:appoiment_app/view/boking_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    navigateToNextScreen(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('assets/images/splash_bg.png', fit: BoxFit.cover),
      ),
    );
  }
}

Future<void> navigateToNextScreen(BuildContext context) async {
  TokenManager.getToken().then((token) async {
    if (token != null && token.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BokingScreen()),
      );
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  });
}
