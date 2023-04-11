import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-settings.dart';
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
          'Мобильное приложение PlayTennis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'По любым вопросам касающихся работы приложения или сотрудничества, обращайтесь ко мне:',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Дмитрий Сердюков:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          child: const Text(
            'Ссылка на меня на платформе',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed('/player/${MainSettings.dimaserdPlayerId}');
          },
        ),
        const SizedBox(height: 5),
        InkWell(
          child: const Text(
            'Телеграмм: @dimaserd',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            var telegramUser = Uri.parse("tg://resolve?domain=@dimaserd");
            launchUrl(telegramUser);
          },
        ),
        const SizedBox(height: 5),
        InkWell(
          child: const Text(
            'Телефон: +7 916 604-49-60',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            var phoneNumber = Uri.parse("tel://+79166044960");
            launchUrl(phoneNumber);
          },
        ),
        const SizedBox(height: 5),
        const Text(
          'Если вам нужна своя платформа или приложение для вашего бизнеса, буду рад вам помочь)',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Другие способы работы с платформой:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          child: const Text(
            'Телеграм-бот PlayTennis',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            var telegramUser =
                Uri.parse("tg://resolve?domain=@tennis_play_bot");
            launchUrl(telegramUser);
          },
        ),
        const SizedBox(height: 5),
        InkWell(
          child: const Text(
            'Web-приложение PlayTennis',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            MainAppExtensions.trylaunchAppUrl(
              "/ptc/tournaments",
              (er) {
                BaseApiResponseUtils.showSuccess(context, er);
              },
            );
          },
        ),
      ],
    );
  }
}
