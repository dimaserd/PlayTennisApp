import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'TournamentGameToSelect.dart';

class TournamentGamesList extends StatelessWidget {
  final TournamentDetailedModel tournament;
  const TournamentGamesList({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    var games = tournament.events!;

    return Expanded(
      child: games.isEmpty
          ? Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Loading(text: "Игры не найдены"),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TournamentGameToSelect(
                  tournament: tournament,
                  game: games[index],
                  onChange: () {},
                );
              },
              itemCount: games.length,
            ),
    );
  }
}
