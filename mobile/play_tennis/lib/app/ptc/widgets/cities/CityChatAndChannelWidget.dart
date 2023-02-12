import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import '../../../../main-extensions.dart';

class CityChatAndChannelWidget extends StatelessWidget {
  final PublicTelegramChatForCityModel model;
  final String cityName;

  const CityChatAndChannelWidget({
    super.key,
    required this.model,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        model.chatLink != null && model.chatLink != ""
            ? Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: "Телеграм-чат города $cityName",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => MainAppExtensions.launchUrlInBrowser(
                                model.chatLink!,
                              )),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        model.channelLink != null && model.channelLink != ""
            ? Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: "Телеграм-канал города $cityName",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => MainAppExtensions.launchUrlInBrowser(
                              model.channelLink!,
                            )),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
