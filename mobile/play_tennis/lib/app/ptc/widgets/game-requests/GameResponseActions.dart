import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/ResponseForGameRequestIdModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class GameResponseActions extends StatelessWidget {
  const GameResponseActions({
    Key? key,
    required this.request,
    required this.response,
    required this.loginData,
  }) : super(key: key);

  final GameRequestDetailedModel request;
  final GameRequestResponseSimpleModel response;
  final CurrentLoginData loginData;

  List<Widget> getButtons(BuildContext context) {
    if (request.author == null || request.author!.id != loginData.userId) {
      return [];
    }

    if (response.acceptedByRequestAuthor) {
      return [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size.fromHeight(36),
            ),
            onPressed: () {
              BaseApiResponseUtils.showError(context, "Не реализовано");
              MyApp.inProccess = true;
              MyApp.inProccess = false;
            },
            child: const Text("Запросить контакты"),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ];
    }

    return [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () {
            if (MyApp.inProccess) {
              return;
            }

            MyApp.inProccess = true;
            var model = ResponseForGameRequestIdModel(
              gameRequestId: request.id!,
              playerId: response.author!.id!,
            );
            AppServices.gameRequestsService
                .acceptResponse(model, (e) {})
                .then((resp) {
              MyApp.inProccess = false;
              BaseApiResponseUtils.handleResponse(context, resp);
            });
          },
          child: const Text("Принять"),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () {
            BaseApiResponseUtils.showError(context, "Не реализовано");
          },
          child: const Text("Отказать"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: getButtons(context),
        ),
      ),
    );
  }
}
