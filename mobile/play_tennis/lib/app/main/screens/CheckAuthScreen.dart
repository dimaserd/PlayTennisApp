import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../logic/clt/models/CurrentLoginData.dart';
import '../../../main.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  CheckAuthScreenState createState() => CheckAuthScreenState();
}

class CheckAuthScreenState extends State<CheckAuthScreen> {
  CurrentLoginData? loginData;

  @override
  void initState() {
    super.initState();
    _getLoginData().then((value) {
      if (value) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoaderOverlay(
      child: Center(),
    );
  }

  Future<bool> _getLoginData() {
    return MyApp.loginService.checkLogin();
  }
}
