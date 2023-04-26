import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/main-services.dart';
import 'GamesList.dart';

class SearchGamesWidget extends StatefulWidget {
  final CurrentLoginData loginData;
  final String playerId;

  const SearchGamesWidget({
    super.key,
    required this.loginData,
    required this.playerId,
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
                ignorePlayerIds: [
                  widget.loginData.userId!,
                  widget.playerId,
                ],
                onChange: (p) {},
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  getData() {
    var playerRequest = SearchGamesRequest(
      count: 30,
      offSet: 0,
      opponentPlayerId: null,
      playerId: widget.playerId,
      q: null,
    );

    AppServices.gameService.searchGames(playerRequest, (e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при поиске игр.",
      );
    }).then((value) {
      games = value.list;
      if (mounted) {
        setState(() {
          gamesLoaded = true;
        });
      }
    });
  }
}
