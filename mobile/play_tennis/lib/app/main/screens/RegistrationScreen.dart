import 'package:flutter/material.dart';
import '../widgets/RegistrationForm.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RegistrationForm(
            onLogin: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/profile", (r) => false);
            },
          ),
        ],
      ),
    );
  }
}
