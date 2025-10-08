import 'package:appoiment_app/controller/pationt_controller.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/view/auth/login_screen.dart';
import 'package:appoiment_app/view/boking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<PationtController>(context, listen: false).fetchPatients();
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookingScreen()),
      );
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  });
}
