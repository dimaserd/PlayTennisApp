import 'package:flutter/material.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'GameRequestToSelect.dart';

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
    return SizedBox(
        height: 300,
        child: requests.isEmpty
            ? Column(children: const [
                Center(
                  child: Text("Заявки на игру не найдены"),
                ),
              ])
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return GameRequestToSelect(
                    request: requests[index],
                    loginData: loginData,
                    onChange: onChange,
                  );
                },
                itemCount: requests.length,
              ));
  }
}
