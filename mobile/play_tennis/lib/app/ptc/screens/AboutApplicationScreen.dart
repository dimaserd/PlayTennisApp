import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/extensions/AppUtils.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApplicationScreen extends StatelessWidget {
  const AboutApplicationScreen({super.key});

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
                  text: "Информация",
                ),
                Tab(
                  text: "Бэклог",
                ),
              ],
            ),
            title: const Text('О приложении'),
          ),
          drawer: const SideDrawer(),
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
      const MainApplicationInfo(),
      const Loading(text: "Бэклог пока не реализован"),
    ];
  }
}

class MainApplicationInfo extends StatelessWidget {
  const MainApplicationInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Мобильное приложение ${MainSettings.appName}',
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
                MainRoutes.toPlayerCard(context, MainSettings.dimaserdPlayerId);
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
                var telegramUser =
                    Uri.parse(MainSettings.dimaSerdTelegramUrl());
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
            ToTelegramButton(
              text: "Бот ${MainSettings.appName}",
              tapHandler: () {
                var uri = Uri.parse(TelegramBotSettings.link());
                launchUrl(uri);
              },
            ),
            const SizedBox(height: 5),
            const ToWebAppWidget(),
            const SizedBox(height: 25),
            const Text(
              'Продолжая работу с приложением вы соглашаетесь со следующими документами:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              child: const Text(
                'Политика обработки персональных данных',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                AppUtils.tryAndShowMessageIfError(
                  () {
                    var uri = Uri.parse(MainSettings.privacyPolicy);
                    launchUrl(uri);
                  },
                  context,
                  "Произошла ошибка при переходе к политике обработки персональных данных. Пожалуйста, обратитесь к администратору портала.",
                );
              },
            ),
            const SizedBox(height: 5),
            InkWell(
              child: const Text(
                'Соглашение об обработке персональных данных и информационной рассылке сервиса',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                AppUtils.tryAndShowMessageIfError(
                  () {
                    var uri = Uri.parse(MainSettings.agreement);
                    launchUrl(uri);
                  },
                  context,
                  "Произошла ошибка при переходе к соглашению об обработке персональных данных и информационной рассылке сервиса. Пожалуйста, обратитесь к администратору портала.",
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ToWebAppWidget extends StatelessWidget {
  const ToWebAppWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MainAppExtensions.trylaunchAppUrl(
          "/ptc/tournaments",
          (er) {
            BaseApiResponseUtils.showError(context, er);
          },
        );
      },
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Card(
          color: Colors.black,
          margin: EdgeInsets.only(
            top: 5,
          ),
          elevation: 5,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Image(
                  height: 30,
                  width: 30,
                  image: NetworkImage(
                    "${MainSettings.domain}/images/logos/internet.webp",
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Web приложение",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
