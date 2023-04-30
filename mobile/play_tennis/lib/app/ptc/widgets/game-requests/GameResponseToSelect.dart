import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameResponseActions.dart';
import 'package:play_tennis/app/ptc/widgets/players/PlayerDataWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/ResponseForGameRequestIdModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class GameResponseToSelect extends StatelessWidget {
  final GameRequestResponseSimpleModel response;
  final CurrentLoginData loginData;
  final GameRequestDetailedModel request;
  final Function onChanged;
  const GameResponseToSelect({
    super.key,
    required this.response,
    required this.loginData,
    required this.request,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var player = response.author!;
    return GestureDetector(
      onTap: () {
        MainRoutes.toPlayerCard(context, player.id!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        elevation: 5,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            PlayerDataWidget(
              player: player,
            ),
            const SizedBox(
              height: 5,
            ),
            loginData.userId != player.id
                ? GameResponseActions(
                    request: request,
                    response: response,
                    loginData: loginData,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget deleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: const Size.fromHeight(30),
        ),
        onPressed: () {
          BaseApiResponseUtils.showError(context, "Не реализовано");
        },
        child: const Text("Удалить отклик"),
      ),
    );
  }

  acceptResponseHandler(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    var model = ResponseForGameRequestIdModel(
      gameRequestId: request.id!,
      playerId: response.author!.id,
    );
    AppServices.gameRequestsService.acceptResponse(model, (e) {}).then(
      (value) {
        BaseApiResponseUtils.handleResponse(
          context,
          value,
        );
        MyApp.inProccess = false;
      },
    );
  }
}
