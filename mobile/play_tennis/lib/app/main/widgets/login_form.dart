import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/PasswordInput.dart';
import 'package:play_tennis/app/main/widgets/Inputs/TextInput.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/models.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';

class LoginForm extends StatefulWidget {
  final Function onLogin;
  const LoginForm({super.key, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passTextController = TextEditingController();

  final EdgeInsets padding = const EdgeInsets.only(
    top: 10,
    left: 20,
    right: 20,
  );
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
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextButton(
          child: const Text("Забыли пароль?"),
          onPressed: () {
            Navigator.of(context).pushNamed("/forgotpass");
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextButton(
          child: const Text("Демо-доступ"),
          onPressed: () {
            Navigator.of(context).pushNamed(MainRoutes.checkAuth);
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

  onLoginHandler(bool isSucceeded, String message) {
    BaseApiResponseUtils.handleResponse(
        context, BaseApiResponse(isSucceeded: isSucceeded, message: message));
  }

  Future<void> onPressed(BuildContext context) async {
    if (isLoginInProccess) {
      return;
    }

    setState(() {
      isLoginInProccess = true;
    });

    try {
      var data = await AppServices.loginService.login(
        emailTextController.text,
        passTextController.text,
      );

      var message =
          data.succeeded ? "Вы успешно авторизованы" : data.errorMessage!;

      onLoginHandler(data.succeeded, message);

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
