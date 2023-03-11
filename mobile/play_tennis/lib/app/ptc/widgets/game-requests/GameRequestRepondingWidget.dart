import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_tennis/app/main/extensions/TimePickerUtils.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class GameRequestRepondingWidget extends StatelessWidget {
  final CurrentLoginData loginData;
  final GameRequestSimpleModel request;
  final Function onChange;

  const GameRequestRepondingWidget({
    super.key,
    required this.loginData,
    required this.request,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: getWidgetsForResponse(context),
    );
  }

  String getDateString() {
    if (DateUtils.dateOnly(request.matchDateUtc) ==
        DateUtils.dateOnly(DateTime.now())) {
      return "Сегодня ${getTimeString()}";
    }

    //По-умолчанию используется московское время
    return "${DateFormat.MMMMd('ru').format(request.matchDateUtc.toLocal())} ${getTimeString()}";
  }

  String getTimeString() {
    return TimePickerUtils.formatDateTime(
        request.matchDateUtc.add(const Duration(hours: 3)));
  }

  List<Widget> getWidgetsForResponse(BuildContext context) {
    List<Widget> result = [
      Container(
        height: 5,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          getDateString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        height: 5,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          request.description!,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      Container(
        height: 5,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Количество откликов: ${request.respondsCount}",
          style: const TextStyle(fontSize: 15),
        ),
      )
    ];

    if (loginData.userId != request.author!.id) {
      result.add(request.hasMyRespond
          ? const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Вы уже откликнулись на данную заявку",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(36), // NEW
              ),
              onPressed: () {
                respond(context);
              },
              child: const Text("Откликнуться"),
            ));
    }

    if (loginData.userId == request.author!.id) {
      result.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: const Size.fromHeight(36), // NEW
        ),
        onPressed: () {
          delete(context);
        },
        child: const Text("Удалить заявку"),
      ));
    }
    return result;
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

  delete(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;

    AppServices.gameRequestsService.remove(request.id!).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);

      if (value.isSucceeded) {
        onChange();
      }
      MyApp.inProccess = false;
    });
  }
}
