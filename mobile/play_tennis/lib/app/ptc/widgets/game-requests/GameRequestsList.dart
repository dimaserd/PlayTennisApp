import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestToSelect.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';

class GameRequestsList extends StatelessWidget {
  final List<GameRequestSimpleModel> requests;
  final CurrentLoginData loginData;
  final Function onChange;
  final bool isLoader;

  const GameRequestsList(
      {super.key,
      required this.requests,
      required this.loginData,
      required this.onChange,
      required this.isLoader});

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? Column(children: [
            Center(
              child: loading(context),
            ),
          ])
        : SizedBox(
            height: MediaQuery.of(context).size.height *
                0.5, // установите нужную высоту
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return GameRequestToSelect(
                  request: requests[index],
                  loginData: loginData,
                );
              },
              itemCount: requests.length,
            ),
          );
  }

  Widget loading(BuildContext context) {
    var size = MediaQuery.of(context).size.width / 2;
    return isLoader
        ? AnimatedCircleLoading(height: size)
        : const Text("Заявки на игру не найдены");
  }
}
