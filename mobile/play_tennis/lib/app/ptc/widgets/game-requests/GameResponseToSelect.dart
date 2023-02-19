import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/AcceptGameRequestResponse.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import '../players/PlayerDataWidget.dart';
import 'GameResponseActions.dart';

class GameResponseToSelect extends StatelessWidget {
  final GameRequestResponseSimpleModel response;
  final CurrentLoginData loginData;
  final String requestId;
  final Function onChanged;
  const GameResponseToSelect({
    super.key,
    required this.response,
    required this.loginData,
    required this.requestId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var player = response.author!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/player/${player.id}");
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        elevation: 5,
        child: Column(
          children: [
            PlayerDataWidget(player: player),
            const SizedBox(
              height: 5,
            ),
            loginData.userId == player.id
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size.fromHeight(30),
                      ),
                      onPressed: () {
                        BaseApiResponseUtils.showError(
                            context, "Не реализовано");
                      },
                      child: const Text("Удалить отклик"),
                    ),
                  )
                : const SizedBox.shrink(),
            loginData.userId != player.id
                ? GameResponseActions(requestId: requestId, response: response)
                : const SizedBox.shrink(),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  acceptResponseHandler(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    var model = AcceptGameRequestResponse(
      gameRequestId: requestId,
      playerId: response.author!.id,
    );
    AppServices.gameRequestsService.acceptResponse(model).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);
      MyApp.inProccess = false;
    });
  }
}
