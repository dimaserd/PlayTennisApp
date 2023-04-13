import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/games/CreateSinglesGame.dart';

class SearchGamesRequest {
  late String? playerId;
  late String? opponentPlayerId;
  late String? q;
  late int? count;
  late int offSet;

  SearchGamesRequest({
    required this.playerId,
    required this.opponentPlayerId,
    required this.q,
    required this.count,
    required this.offSet,
  });

  factory SearchGamesRequest.fromJson(Map<String, dynamic> json) =>
      SearchGamesRequest(
        playerId: json["playerId"],
        opponentPlayerId: json["opponentPlayerId"],
        q: json["q"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'opponentPlayerId': opponentPlayerId,
        'q': q,
        'count': count,
        'offSet': offSet,
      };
}

class GetListSearchModel {
  late int? count;
  late int offSet;

  GetListSearchModel({
    required this.count,
    required this.offSet,
  });

  factory GetListSearchModel.fromJson(Map<String, dynamic> json) =>
      GetListSearchModel(
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'offSet': offSet,
      };
}

class SinglesGameSimpleModel {
  late String? id;
  late int? imageFileId;
  late String? courtType;
  late List<GamePlayerModelWithWinner>? players;
  late TennisMatchData? scoreData;
  late DateTime? playedOnUtc;
  late String? court;

  SinglesGameSimpleModel({
    required this.id,
    required this.imageFileId,
    required this.courtType,
    required this.players,
    required this.scoreData,
    required this.playedOnUtc,
    required this.court,
  });

  factory SinglesGameSimpleModel.fromJson(Map<String, dynamic> json) =>
      SinglesGameSimpleModel(
        id: json["id"],
        imageFileId: json["imageFileId"],
        courtType: json["courtType"],
        players: List<GamePlayerModelWithWinner>.from(
            json["players"].map((x) => GamePlayerModelWithWinner.fromJson(x))),
        scoreData: json["scoreData"] != null
            ? TennisMatchData?.fromJson(json["scoreData"])
            : null,
        playedOnUtc: json["playedOnUtc"] != null
            ? DateTime.parse(json["playedOnUtc"])
            : null,
        court: json["court"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageFileId': imageFileId,
        'courtType': courtType,
        'players': players?.map((e) => e.toJson()).toList(),
        'scoreData': scoreData?.toJson(),
        'playedOnUtc': playedOnUtc,
        'court': court,
      };
}

class GamePlayerModelWithWinner {
  late String? teamName;
  late bool isWinner;
  late PlayerSimpleModel? player;

  GamePlayerModelWithWinner({
    required this.teamName,
    required this.isWinner,
    required this.player,
  });

  factory GamePlayerModelWithWinner.fromJson(Map<String, dynamic> json) =>
      GamePlayerModelWithWinner(
        teamName: json["teamName"],
        isWinner: json["isWinner"],
        player: json["player"] != null
            ? PlayerSimpleModel?.fromJson(json["player"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'teamName': teamName,
        'isWinner': isWinner,
        'player': player?.toJson(),
      };
}

class PlayerSimpleModel {
  late String? id;
  late bool sex;
  late String? name;
  late String? surname;
  late String? patronymic;
  late int? avatarFileId;
  late String? ntrpRating;
  late double rating;

  PlayerSimpleModel({
    required this.id,
    required this.sex,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.avatarFileId,
    required this.ntrpRating,
    required this.rating,
  });

  factory PlayerSimpleModel.fromJson(Map<String, dynamic> json) =>
      PlayerSimpleModel(
        id: json["id"],
        sex: json["sex"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        avatarFileId: json["avatarFileId"],
        ntrpRating: json["ntrpRating"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sex': sex,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'avatarFileId': avatarFileId,
        'ntrpRating': ntrpRating,
        'rating': rating,
      };
}

class GameService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/game/";
  GameService(this.networkService);

  Future<BaseApiResponse> create(CreateSinglesGame model) async {
    var map = model.toJson();

    var bodyJson = jsonEncode(map);
    var responseBody =
        await networkService.postData('${baseUrl}create', bodyJson);

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }

  Future<GetListResult<SinglesGameSimpleModel>> searchMine(
      GetListSearchModel model, Function(String) errorHandler) async {
    var map = model.toJson();

    var bodyJson = jsonEncode(map);
    var responseBody = await networkService.postDataV2(
        '${baseUrl}search/mine', bodyJson, errorHandler);

    try {
      var json = jsonDecode(responseBody);

      var result = GetListResult(
        totalCount: json["totalCount"],
        list: List<SinglesGameSimpleModel>.from(
          json["list"].map((x) => SinglesGameSimpleModel.fromJson(x)),
        ),
        count: json["count"],
        offSet: json["offSet"],
      );

      return result;
    } catch (e) {
      errorHandler(e.toString());
      return GetListResult(totalCount: 0, list: [], count: 0, offSet: 0);
    }
  }

  Future<GetListResult<SinglesGameSimpleModel>> searchGames(
      SearchGamesRequest model) async {
    var map = model.toJson();

    var bodyJson = jsonEncode(map);
    var responseBody =
        await networkService.postData('${baseUrl}search', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<SinglesGameSimpleModel>.from(
        json["list"].map((x) => SinglesGameSimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }
}
