import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestToSelect.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';

class GameRequestsList extends StatelessWidget {
  final List<GameRequestSimpleModel> requests;
  final CurrentLoginData loginData;
  final Function onChange;

  const GameRequestsList({
    super.key,
    required this.requests,
    required this.loginData,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: requests.isEmpty
            ? Column(children: const [
                Center(
                  child: Text("Заявки на игру не найдены"),
                ),
              ])
            : Container(
              color: Colors.transparent,
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
            ));
  }
}
