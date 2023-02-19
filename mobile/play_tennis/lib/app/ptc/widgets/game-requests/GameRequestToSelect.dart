import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import '../../../../main-services.dart';
import '../players/PlayerDataWidget.dart';
import 'GameRequestRepondingWidget.dart';

class GameRequestToSelect extends StatelessWidget {
  final GameRequestSimpleModel request;
  final CurrentLoginData loginData;
  final Function onChange;
  GameRequestToSelect({
    super.key,
    required this.request,
    required this.loginData,
    required this.onChange,
  });
  bool inProccess = false;

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
            PlayerDataWidget(player: player),
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
    if (inProccess) {
      return;
    }

    inProccess = true;

    AppServices.gameRequestsService.respond(request.id!).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);

      inProccess = false;
    });
  }
}
