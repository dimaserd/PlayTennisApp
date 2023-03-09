import 'package:flutter/material.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/services/GameService.dart';
import 'GameToSelect.dart';

class GamesList extends StatelessWidget {
  final List<SinglesGameSimpleModel> games;
  final CurrentLoginData loginData;
  final Function onChange;

  const GamesList({
    super.key,
    required this.games,
    required this.loginData,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: games.isEmpty
            ? Column(children: const [
                Center(
                  child: Text("Игры не найдены"),
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
