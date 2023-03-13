import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestRepondingWidget.dart';
import 'package:play_tennis/app/ptc/widgets/players/PlayerDataWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class GameRequestToSelect extends StatelessWidget {
  final GameRequestSimpleModel request;
  final CurrentLoginData loginData;
  final Function onChange;
  const GameRequestToSelect({
    super.key,
    required this.request,
    required this.loginData,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var player = request.author!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/game-request/${request.id}");
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        elevation: 5,
        child: Column(
          children: [
            PlayerDataWidget(
              player: player,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GameRequestRepondingWidget(
                loginData: loginData,
                request: request,
                onChange: onChange,
              ),
            ),
            Container(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  respond(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    AppServices.gameRequestsService.respond(request.id!).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);

      MyApp.inProccess = false;
    });
  }
}
