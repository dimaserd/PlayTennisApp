import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/RegistrationForm.dart';

class AdvancedRegistrationScreen extends StatelessWidget {
  const AdvancedRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
      ),
    );
  }
}
