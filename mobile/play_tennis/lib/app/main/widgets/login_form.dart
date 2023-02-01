import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/models.dart';
import '../../../main-settings.dart';
import '../../../main.dart';
import 'Inputs/PasswordInput.dart';
import 'Inputs/TextInput.dart';
import 'Loading.dart';

class LoginForm extends StatefulWidget {
  final Function onLogin;
  const LoginForm({super.key, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passTextController = TextEditingController();

  final EdgeInsets padding =
      const EdgeInsets.only(top: 10, left: 20, right: 20);
  bool isLoginInProccess = false;

  List<Widget> getWidgets() {
    if (isLoginInProccess) {
      return [
        const Loading(text: "Авторизуемся"),
      ];
    }

    return [
      Padding(
        padding: padding,
        child: TextInput(
          labelText: "Логин",
          textController: emailTextController,
        ),
      ),
      Padding(
        padding: padding,
        child: PasswordInput(
          textController: passTextController,
        ),
      ),
      Padding(
        padding: padding,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          onPressed: () => onPressed(context),
          child: const Text("Войти"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: TextButton(
          child: const Text("Регистрация"),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/registration", (r) => false);
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 15, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          const Text(
            MainSettings.appName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Image.asset(
            MainSettings.imageLogoPath,
            height: 150,
            width: 150,
          ),
          ...getWidgets(),
        ],
      ),
    ));
  }

  Future<void> onPressed(BuildContext context) async {
    if (isLoginInProccess) {
      return;
    }

    setState(() {
      isLoginInProccess = true;
    });

    try {
      var data = await MyApp.loginService.login(
        emailTextController.text,
        passTextController.text,
      );

      var message =
          data.succeeded ? "Вы успешно авторизованы" : data.errorMessage!;

      BaseApiResponseUtils.handleResponse(context,
          BaseApiResponse(isSucceeded: data.succeeded, message: message));

      if (data.succeeded) {
        widget.onLogin();
      }
      setState(() {
        isLoginInProccess = false;
      });
    } catch (e) {
      print(e);
      BaseApiResponseUtils.showError(context,
          "Произошла ошибка при авторизации. Проверьте интернет соединение.");

      setState(() {
        isLoginInProccess = false;
      });
    } finally {}
  }
}
