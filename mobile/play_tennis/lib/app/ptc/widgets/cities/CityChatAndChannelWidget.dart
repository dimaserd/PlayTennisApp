import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/main-extensions.dart';
import 'package:play_tennis/main-settings.dart';

class CityChatAndChannelWidget extends StatelessWidget {
  final PublicTelegramChatForCityModel model;
  final String cityName;
  final String text;

  const CityChatAndChannelWidget({
    super.key,
    required this.model,
    required this.cityName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Column(
              children: [
                model.chatLink != null && model.chatLink != ""
                    ? ToTelegramButton(
                        tapHandler: () {
                          MainAppExtensions.launchUrlInBrowser(
                            model.chatLink!,
                            (e) {
                              BaseApiResponseUtils.showError(
                                context,
                                "Произошла ошибка при открытия телеграм-чата. Обратитесь к администратору портала",
                              );
                            },
                          );
                        },
                        text: "чат города $cityName",
                      )
                    : const SizedBox.shrink(),
                model.channelLink != null && model.channelLink != ""
                    ? ToTelegramButton(
                        tapHandler: () {
                          MainAppExtensions.launchUrlInBrowser(
                            model.channelLink!,
                            (e) {
                              BaseApiResponseUtils.showError(
                                context,
                                "Произошла ошибка при открытия телеграм-чата. Обратитесь к администратору портала",
                              );
                            },
                          );
                        },
                        text: "канал города $cityName",
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class ToTelegramButton extends StatelessWidget {
  final String text;
  final Function() tapHandler;

  const ToTelegramButton({
    super.key,
    required this.text,
    required this.tapHandler,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapHandler();
      },
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Card(
          color: const Color.fromARGB(255, 51, 187, 255),
          margin: const EdgeInsets.only(
            top: 5,
          ),
          elevation: 5,
          child: Center(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Image(
                  height: 30,
                  width: 30,
                  image: NetworkImage(
                      "${MainSettings.domain}/images/telegram/TelegramLogo.png"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: const TextStyle(
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
