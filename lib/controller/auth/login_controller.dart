import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  Future<void> login(BuildContext context) async {
    setLoading(true);
    try {
      // Assuming you have a Login service and TokenManager
      // import 'package:appoiment_app/service/auth.dart';
      // final loginService = Login();
      // final token = await loginService.login(
      //   _usernameController.text,
      //   _passwordController.text,
      // );
      // await TokenManager.saveToken(token);
      // Handle successful login, e.g., navigate to home screen
      print('Login successful!');
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen
      // );
    } catch (e) {
      // Handle login error
      print('Login failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Failed: ${e.toString()}')));
    } finally {
      setLoading(false);
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
