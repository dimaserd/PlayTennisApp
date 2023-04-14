import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangePassScreen extends StatelessWidget {
  const ChangePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getWidgets(),
        ),
      ),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Сбросить пароль"),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      const ResetPassViaTelegram(),
      const SizedBox(
        height: 30,
      ),
      const ResetPassViaAdmins(),
    ];
  }
}

class ResetPassViaTelegram extends StatelessWidget {
  const ResetPassViaTelegram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          '1) Как сбросить пароль',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: 'Если ваша учетная запись была привязана к ',
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Telegram',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ', то вы можете перейти в '),
              TextSpan(
                text: 'TelegramBot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              TextSpan(text: ',  и ввести туда команду '),
              TextSpan(
                text: '/changepassword',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        InkWell(
            child: const Text(
              "Скопировать команду",
              style: TextStyle(
                color: Color.fromARGB(255, 89, 64, 255),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _tapHandler(context)),
        const SizedBox(height: 10),
        InkWell(
          child: const Text(
            'Телеграм-бот ${MainSettings.appName}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          onTap: () {
            var uri = Uri.parse(TelegramBotSettings.link);
            launchUrl(uri);
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  _tapHandler(BuildContext context) async {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    var text = "/changepassword";

    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Команда скопирована в буфер обмена. Перейдите в телеграм-бот и вставьте ему это сообщение и нажмите отправить",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ));
    });

    MyApp.inProccess = false;
  }
}

class ResetPassViaAdmins extends StatelessWidget {
  const ResetPassViaAdmins({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          '2) Если у вас нет привязки или доступа к Telegram',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text:
                'Администратор портала может изменить вам пароль самостоятельно, для этого вам нужно написать ',
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Дмитрию Сердюкову',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '. ',
              ),
              TextSpan(
                text: 'И попросите его сбросить пароль.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          child: const Text(
            'Телеграмм: @dimaserd',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          onTap: () {
            var telegramUser = Uri.parse("tg://resolve?domain=@dimaserd");
            launchUrl(telegramUser);
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
