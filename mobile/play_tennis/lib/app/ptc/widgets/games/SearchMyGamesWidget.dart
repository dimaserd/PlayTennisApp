import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/games/GamesList.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/main-services.dart';

class SearchMyGamesWidget extends StatefulWidget {
  final CurrentLoginData loginData;
  const SearchMyGamesWidget({
    super.key,
    required this.loginData,
  });

  @override
  State<SearchMyGamesWidget> createState() => _SearchMyGamesWidgetState();
}

class _SearchMyGamesWidgetState extends State<SearchMyGamesWidget> {
  List<SinglesGameSimpleModel> games = [];
  bool gamesLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return gamesLoaded
        ? GamesList(
            games: games,
            ignorePlayerIds: [
              widget.loginData.userId!,
            ],
            onChange: () {},
          )
        : const SizedBox.shrink();
  }

  getData() {
    var playerRequest = GetListSearchModel(
      count: 30,
      offSet: 0,
    );

    AppServices.gameService
        .searchMine(playerRequest, _errorHandler)
        .then((value) {
      games = value.list;
      if (mounted) {
        setState(() {
          gamesLoaded = true;
        });
      }
    });
  }

  void _errorHandler(String error) {
    BaseApiResponseUtils.showError(context, error);
  }
}
