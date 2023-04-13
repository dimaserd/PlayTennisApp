import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangePassScreen extends StatelessWidget {
  const ChangePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              isScrollable: false,
              tabs: [
                Tab(
                  text: "Telegram",
                ),
                Tab(
                  text: "Через поддержку",
                ),
              ],
            ),
            title: const Text('Изменить пароль'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TabBarView(
              children: getWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      const Loading(text: "Бэклог пока не реализован"),
      const ResetPassViaTelegram(),
    ];
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
            fontSize: 16,
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          onTap: () {
            var phoneNumber = Uri.parse("tel://+79166044960");
            launchUrl(phoneNumber);
          },
        ),
        const SizedBox(height: 15),
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
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
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
        InkWell(
          child: const Text(
            'Web-приложение ${MainSettings.appName}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
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
            fontSize: 16,
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
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
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          onTap: () {
            var phoneNumber = Uri.parse("tel://+79166044960");
            launchUrl(phoneNumber);
          },
        ),
        const SizedBox(height: 15),
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
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
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
        InkWell(
          child: const Text(
            'Web-приложение ${MainSettings.appName}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
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
