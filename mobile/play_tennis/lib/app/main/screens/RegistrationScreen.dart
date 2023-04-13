import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/RegistrationForm.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
              isV2: true,
              onLogin: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/change-avatar", (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
