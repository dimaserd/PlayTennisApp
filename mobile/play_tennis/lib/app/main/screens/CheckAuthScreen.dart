import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/main-services.dart';

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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [Loading(text: "Загрузка")],
        ),
      ),
    );
  }

  Future<bool> _getLoginData() {
    return AppServices.loginService.checkLogin();
  }
}
