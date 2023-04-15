import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/main.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramLinkWidget extends StatelessWidget {
  const TelegramLinkWidget({
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
          'Связывание',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Перейдите в телеграм-бот воспользовавшись ссылкой ниже и введите туда команду.",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          child: const Text(
            "Скопировать команду",
            style: TextStyle(
              color: Color.fromARGB(255, 89, 64, 255),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () => _tapHandler(context),
        ),
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
            var telegramUser = Uri.parse(TelegramBotSettings.link);
            launchUrl(telegramUser);
          },
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  _tapHandler(BuildContext context) async {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    var result =
        await AppServices.telegramPlayerService.createTelegramLink((e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при генерации ссылки для связывания с Telegram. ",
      );
    });

    if (!result.isSucceeded) {
      if (context.mounted) {
        _showError(context, result.message);
      }
      MyApp.inProccess = false;
      return;
    }

    var text = result.responseObject.command!;

    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Команда скопирована в буфер обмена. Перейдите в телеграм-бот и вставьте ему это сообщение и нажмите отправить.",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ));
    });

    MyApp.inProccess = false;
  }

  _showError(BuildContext context, String error) {
    BaseApiResponseUtils.showError(context, error);
  }
}
