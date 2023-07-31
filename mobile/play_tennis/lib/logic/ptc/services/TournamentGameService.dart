import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
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

class UpdateGameScoreData {
  late String? gameId;
  late int? imageFileId;
  late TennisMatchData? gameData;

  UpdateGameScoreData({
    required this.gameId,
    required this.imageFileId,
    required this.gameData,
  });

  factory UpdateGameScoreData.fromJson(Map<String, dynamic> json) =>
      UpdateGameScoreData(
        gameId: json["gameId"],
        imageFileId: json["imageFileId"],
        gameData: json["gameData"] != null
            ? TennisMatchData?.fromJson(json["gameData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'imageFileId': imageFileId,
        'gameData': gameData?.toJson(),
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

  Future<BaseApiResponse> updateScore(
    String id,
    model,
    Function(String) onError,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var response = await networkService.postDataV2(
      '/api/ptc/tournament/game/Score/Update',
      bodyJson,
      onError,
    );

    if (response == "null") {
      return BaseApiResponse(isSucceeded: false, message: "Произошла ошибка");
    }

    try {
      var json = jsonDecode(response!);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      onError(e.toString());
    }

    return BaseApiResponse(isSucceeded: false, message: "Произошла ошибка");
  }
}
