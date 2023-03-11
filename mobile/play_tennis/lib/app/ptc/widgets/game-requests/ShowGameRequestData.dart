import 'package:flutter/material.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/extensions/GameRequestMappingExtensions.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import '../players/PlayerDataWidget.dart';
import 'GameRequestRepondingWidget.dart';
import 'GameRequestResponsesList.dart';

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
}
