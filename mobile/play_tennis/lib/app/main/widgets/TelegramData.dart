import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-settings.dart';

class TelegramData extends StatelessWidget {
  final PlayerLocationData locationData;
  final PublicTelegramChatForCityModel telegramCityModel;

  const TelegramData({
    super.key,
    required this.locationData,
    required this.telegramCityModel,
  });

  List<Widget> getButtons(BuildContext context) {
    if (telegramCityModel.channelLink == null &&
        telegramCityModel.chatLink == null) {
      return [
        Card(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text(
                    "Для вашего города не создан чат и канал, вы можете создать их самостоятельно или привязать уже существующий чат в Telegram. Чтобы подлкючить чат к платформе PlayTennis вам необходимо связаться с администраторами портала.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ToTelegramButton(
                    text: "написать администратору",
                    tapHandler: () {
                      MainAppExtensions.launchUrlInBrowser(
                          MainSettings.dimaSerdTelegramUrl, (e) {
                        BaseApiResponseUtils.showError(
                          context,
                          "Произошла ошибка при открытии телеграм-ссылки. Пожалуйста, обратитесь к админстратору портала.",
                        );
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ];
    }

    return [
      telegramCityModel.channelLink != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ToTelegramButton(
                text: "Канал города ",
                tapHandler: () {
                  MainAppExtensions.launchUrlInBrowser(
                      telegramCityModel.channelLink!, (e) {
                    BaseApiResponseUtils.showError(
                      context,
                      "Произошла ошибка при открытии телеграм-канала. Обратитесь к админстратору портала.",
                    );
                  });
                },
              ),
            )
          : const SizedBox.shrink(),
      telegramCityModel.chatLink != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ToTelegramButton(
                tapHandler: () {
                  MainAppExtensions.launchUrlInBrowser(
                      telegramCityModel.chatLink!, (e) {
                    BaseApiResponseUtils.showError(
                      context,
                      "Произошла ошибка при открытии телеграм-чата. Обратитесь к админстратору портала.",
                    );
                  });
                },
                text: "Чат города ",
              ),
            )
          : const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          elevation: 5,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Image(
                  image: NetworkImage(
                    "${MainSettings.domain}/images/telegram/TelegramLogo.png",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Ваше местоположение:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Страна: ${locationData.country!.name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Город: ${locationData.city!.name}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Все заявки на игру, новости, турниры и результаты матчей вашего города попадают в специальный чат, где вы можете обсуждать свои достижения и знакомиться с другими участниками.",
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Если вы не хотите участвовать в обсуждениях и устали от возможного флуда в чате, вы можете подписаться только на канал. Туда также попадают заявки, результаты игр и важные новости.",
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        ...getButtons(context),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
