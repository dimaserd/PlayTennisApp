import 'package:flutter/material.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/services/GameService.dart';
import '../../../../main.dart';
import 'GamesList.dart';

class SearchGamesWidget extends StatefulWidget {
  final CurrentLoginData loginData;
  const SearchGamesWidget({
    super.key,
    required this.loginData,
  });

  @override
  State<SearchGamesWidget> createState() => _SearchGamesWidgetState();
}

class _SearchGamesWidgetState extends State<SearchGamesWidget> {
  List<SinglesGameSimpleModel> games = [];
  bool gamesLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gamesLoaded
            ? GamesList(
                games: games,
                loginData: widget.loginData,
                onChange: (p) {},
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  getData() {
    var playerRequest = GetListSearchModel(
      count: 30,
      offSet: 0,
    );

    MyApp.gameService.searchMine(playerRequest).then((value) {
      games = value.list;
      setState(() {
        gamesLoaded = true;
      });
    });
  }
}
