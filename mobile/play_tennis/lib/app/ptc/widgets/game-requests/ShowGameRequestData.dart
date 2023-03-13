import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestRepondingWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestResponsesList.dart';
import 'package:play_tennis/app/ptc/widgets/players/PlayerDataWidget.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/extensions/GameRequestMappingExtensions.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowGameRequestData extends StatelessWidget {
  final GameRequestDetailedModel request;
  final List<GameRequestResponseSimpleModel> responses;
  final CurrentLoginData loginData;
  final Function onChange;

  const ShowGameRequestData({
    super.key,
    required this.request,
    required this.responses,
    required this.loginData,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var player = request.author!;
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          elevation: 5,
          child: Column(
            children: [
              PlayerDataWidget(
                player: player,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GameRequestRepondingWidget(
                        loginData: loginData,
                        request: GameRequestMappingExtensions.map(request),
                        onChange: onChange,
                      ),
                    ),
                    Container(
                      height: 5,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        GameRequestResponsesList(
          requestId: request.id!,
          responses: responses,
          loginData: loginData,
        ),
      ],
    );
  }

  Widget getContactData(bool showContactData) {
    if (showContactData) {
      var player = request.author!;

      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Ваш отклик принят",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: const Text(
                  'Телеграмм: @dimaserd',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onTap: () {
                  var telegramUser = Uri.parse("tg://resolve?domain=@dimaserd");
                  launchUrl(telegramUser);
                },
              ),
              const SizedBox(height: 5),
              InkWell(
                child: Text(
                  'Телефон: ${player.phoneNumber}',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onTap: () {
                  var phoneNumber = Uri.parse("tel://${player.phoneNumber}");
                  launchUrl(phoneNumber);
                },
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
