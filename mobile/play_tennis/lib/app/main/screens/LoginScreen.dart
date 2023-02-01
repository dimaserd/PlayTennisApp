import 'package:flutter/material.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoginForm(
            onLogin: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/home", (r) => false);
            },
          ),
        ],
      ),
    );
  }
}
