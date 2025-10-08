import 'package:appoiment_app/controller/auth/login_controller.dart';
import 'package:appoiment_app/service/auth.dart';
import 'package:appoiment_app/view/boking_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: MediaQuery.of(context).viewInsets.bottom == 0
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'By creating or logging into an account you are agreeing \nwith our ',
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(
                'assets/images/image copy.png',
                width: 40,
                height: 40,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  "Login or register to book \n your appointments",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Gap(10),
                  TextFormField(
                    controller: provider.usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Gap(20),
                  Row(
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Gap(10),
                  TextFormField(
                    controller: provider.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Gap(50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF006837),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              provider.setLoading(true);
                              await login(
                                provider.usernameController.text,
                                provider.passwordController.text,
                                context,
                              );
                              provider.setLoading(false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF006837),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  login(email, password, context) async {
    await Login.login(email, password)
        .then((value) async {
          await TokenManager.saveToken(value);
          print('Token saved: $value');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Login Successful'),
            ),
          );
        })
        .catchError((error) {
          print('Login error: $error');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login Failed: $error')));
        });
  }
}
