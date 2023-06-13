import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/games/GamesList.dart';

class TournamentBracket extends StatefulWidget {
  @override
  _TournamentBracketState createState() => _TournamentBracketState();
}

class _TournamentBracketState extends State<TournamentBracket> {
  // Список списков, который представляет каждый раунд и команды в нем
  List<List<String>> rounds = [
    [
      'Команда 1',
      'Команда 2',
      'Команда 3',
      'Команда 4',
      'Команда 5',
      'Команда 6',
      'Команда 7',
      'Команда 8'
    ],
    ['Команда 3', 'Команда 4', 'Команда 7', 'Команда 8'],
    ['Команда 4', 'Команда 7']
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: rounds.length,
      itemBuilder: (context, index) {
        return Round(
          teams: rounds[index],
        );
      },
    );
  }
}

class Round extends StatelessWidget {
  final List<String> teams;
  Round({required this.teams});

  Widget buildStack() {
    switch (teams.length) {
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TeamTile(name: teams[0]),
            const SizedBox(height: 195),
            TeamTile(name: teams[1]),
          ],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 320,
              width: 120,
              child: Stack(
                children: [
                  Positioned(top: 60, child: TeamTile(name: teams[0])),
                  Positioned(top: 190, child: TeamTile(name: teams[1])),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: 120,
              child: Stack(
                children: [
                  Positioned(top: 0, child: TeamTile(name: teams[2])),
                  Positioned(top: 130, child: TeamTile(name: teams[3])),
                ],
              ),
            ),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: teams.map((team) => TeamTile(name: team)).toList(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: buildStack(),
    );
  }
}

class TeamTile extends StatelessWidget {
  final String name;

  const TeamTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(name),
      ),
    );
  }
}
