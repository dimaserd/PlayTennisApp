import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'TournamentGameToSelect.dart';

class TournamentGamesList extends StatelessWidget {
  final TournamentDetailedModel tournament;
  final Function pullRefresh;
  const TournamentGamesList(
      {super.key, required this.tournament, required this.pullRefresh});

  Future<void> _refreshData() async {
    pullRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var games = tournament.events!;

    return games.isEmpty
        ? const Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Loading(text: "Игры не найдены"),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
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
