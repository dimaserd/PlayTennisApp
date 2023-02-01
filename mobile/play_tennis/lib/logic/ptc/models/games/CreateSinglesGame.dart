import 'TennisSetData.dart';

class CreateSinglesGame {
  late String? opponentPlayerId;
  late int? imageFileId;
  late String? cityId;
  late String? court;
  late String? courtType;
  late DateTime playedOnUtc;
  late TennisMatchData? gameData;

  CreateSinglesGame({
    required this.opponentPlayerId,
    required this.imageFileId,
    required this.cityId,
    required this.court,
    required this.courtType,
    required this.playedOnUtc,
    required this.gameData,
  });

  factory CreateSinglesGame.fromJson(Map<String, dynamic> json) =>
      CreateSinglesGame(
        opponentPlayerId: json["opponentPlayerId"],
        imageFileId: json["imageFileId"],
        cityId: json["cityId"],
        court: json["court"],
        courtType: json["courtType"],
        playedOnUtc: DateTime.parse(json["playedOnUtc"]),
        gameData: json["gameData"] != null
            ? TennisMatchData?.fromJson(json["gameData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'opponentPlayerId': opponentPlayerId,
        'imageFileId': imageFileId,
        'cityId': cityId,
        'court': court,
        'courtType': courtType,
        'playedOnUtc': playedOnUtc.toIso8601String(),
        'gameData': gameData?.toJson(),
      };
}

class TennisMatchData {
  late List<TennisSetData>? sets;
  late String? winnerPlayerId;

  TennisMatchData({
    required this.sets,
    required this.winnerPlayerId,
  });

  factory TennisMatchData.fromJson(Map<String, dynamic> json) =>
      TennisMatchData(
        sets: List<TennisSetData>.from(
            json["sets"].map((x) => TennisSetData.fromJson(x))),
        winnerPlayerId: json["winnerPlayerId"],
      );

  Map<String, dynamic> toJson() => {
        'sets': sets?.map((x) => x.toJson()).toList(),
        'winnerPlayerId': winnerPlayerId,
      };
}
