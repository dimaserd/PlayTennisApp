import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/main.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramLinkWidget extends StatelessWidget {
  bool linkCopied = false;

  TelegramLinkWidget({
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
          onTap: () => _createLinkClickHandler(context),
        ),
        const SizedBox(height: 10),
        ToTelegramButton(
          text: "Бот ${MainSettings.appName}",
          tapHandler: () {
            _toBotClickHandler(context);
          },
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  _toBotClickHandler(BuildContext context) {
    if (!linkCopied) {
      BaseApiResponseUtils.showInfo(context,
          "Перед переходом в Telegram-бот вам необходимо скопировать команду. Нажмите на текст выделенный голубым. Это скопирует вам специальную команду в буфео обмена, которую вы потом передадите в Telegram бот.");
      return;
    }

    var uri = Uri.parse(TelegramBotSettings.link());
    launchUrl(uri);
  }

  _createLinkClickHandler(BuildContext context) async {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    var result =
        await AppServices.telegramPlayerService.createTelegramLink((e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при генерации ссылки для связывания с Telegram.",
      );
      MyApp.inProccess = false;
    });

    if (!result.isSucceeded) {
      if (context.mounted) {
        _showError(context, result.message);
      }
      MyApp.inProccess = false;
      return;
    }

    if (result.responseObject == null) {
      if (context.mounted) {
        BaseApiResponseUtils.showError(
            context, "Произошла ошибка при запросе команды");
      }
      return;
    }

    var text = result.responseObject!.command!;

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

    linkCopied = true;

    MyApp.inProccess = false;
  }

  _showError(BuildContext context, String error) {
    BaseApiResponseUtils.showError(context, error);
  }
}
