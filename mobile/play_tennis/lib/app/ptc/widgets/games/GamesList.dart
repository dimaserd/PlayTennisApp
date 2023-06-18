import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'GameToSelect.dart';

class GamesList extends StatelessWidget {
  final List<SinglesGameSimpleModel> games;
  final List<String> ignorePlayerIds;
  final VoidCallback onChange;

  const GamesList({
    super.key,
    required this.games,
    required this.onChange,
    required this.ignorePlayerIds,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: games.isEmpty
          ? Column(children: const [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Loading(text: "Игры не найдены"),
              ),
            ])
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return GameToSelect(
                  game: games[index],
                  ignorePlayerIds: ignorePlayerIds,
                  onChange: onChange,
                );
              },
              itemCount: games.length,
            ),
    );
  }
}
