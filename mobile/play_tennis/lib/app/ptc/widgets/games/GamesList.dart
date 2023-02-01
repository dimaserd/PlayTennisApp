import 'package:flutter/material.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/services/GameService.dart';
import 'GameToSelect.dart';

class GamesList extends StatelessWidget {
  final List<SinglesGameSimpleModel> games;
  final CurrentLoginData loginData;
  final Function onChange;
  final double widgetHeight;

  const GamesList({
    super.key,
    required this.games,
    required this.loginData,
    required this.onChange,
    required this.widgetHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widgetHeight,
        child: games.isEmpty
            ? Column(children: const [
                Center(
                  child: Text("У вас нет игр"),
                ),
              ])
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return GameToSelect(
                    game: games[index],
                    loginData: loginData,
                    onChange: onChange,
                  );
                },
                itemCount: games.length,
              ));
  }
}
