import 'dart:convert';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';

class TournamentGameDetailedModel {
  late TournamentEventModel? game;
  late List<PlayerSimpleModel>? players;
  late TournamentSimpleModel? tournament;

  TournamentGameDetailedModel({
    required this.game,
    required this.players,
    required this.tournament,
  });

  factory TournamentGameDetailedModel.fromJson(Map<String, dynamic> json) =>
      TournamentGameDetailedModel(
        game: json["game"] != null
            ? TournamentEventModel?.fromJson(json["game"])
            : null,
        players: List<PlayerSimpleModel>.from(
            json["players"].map((x) => PlayerSimpleModel.fromJson(x))),
        tournament: json["tournament"] != null
            ? TournamentSimpleModel?.fromJson(json["tournament"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'game': game?.toJson(),
        'players': players?.map((e) => e.toJson()).toList(),
        'tournament': tournament?.toJson(),
      };
}

class TournamentGameService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/tournament/game/";
  TournamentGameService(this.networkService);

  Future<TournamentGameDetailedModel?> getByIdDetailed(
    String id,
    Function(String) errorHandler,
  ) async {
    var response = await networkService.getDataInner(
      '${baseUrl}get/ById/$id/Detailed',
      errorHandler,
    );

    if (response == "null") {
      return null;
    }

    try {
      var json = jsonDecode(response!);

      return TournamentGameDetailedModel.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return null;
    }
  }
}
