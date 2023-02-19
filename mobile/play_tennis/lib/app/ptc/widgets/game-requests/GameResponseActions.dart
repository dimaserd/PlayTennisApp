import 'package:flutter/material.dart';
import '../../../../baseApiResponseUtils.dart';
import '../../../../logic/ptc/models/game-requests/AcceptGameRequestResponse.dart';
import '../../../../logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import '../../../../main-services.dart';
import '../../../../main.dart';

class GameResponseActions extends StatelessWidget {
  const GameResponseActions({
    Key? key,
    required this.requestId,
    required this.response,
  }) : super(key: key);

  final String requestId;
  final GameRequestResponseSimpleModel response;

  List<Widget> getButtons(BuildContext context) {
    if (response.acceptedByRequestAuthor) {
      return [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size.fromHeight(36),
            ),
            onPressed: () {
              MyApp.inProccess = true;
              MyApp.inProccess = false;
            },
            child: const Text("Запросить контакты"),
          ),
        )
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
            var model = AcceptGameRequestResponse(
                gameRequestId: requestId, playerId: response.author!.id!);
            AppServices.gameRequestsService.acceptResponse(model).then((resp) {
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
