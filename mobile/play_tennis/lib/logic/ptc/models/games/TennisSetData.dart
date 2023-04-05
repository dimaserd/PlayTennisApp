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
        'sets': sets?.map((e) => e.toJson()).toList(),
        'winnerPlayerId': winnerPlayerId,
      };
}

class TennisSetData {
  late String? score1;
  late String? score2;
  late TennisTieBreakScoreData? tieBreak;

  TennisSetData({
    required this.score1,
    required this.score2,
    required this.tieBreak,
  });

  factory TennisSetData.fromJson(Map<String, dynamic> json) { 
    return TennisSetData(
        score1: json["score1"],
        score2: json["score2"],
        tieBreak: json["tieBreak"] != null
            ? TennisTieBreakScoreData?.fromJson(json["tieBreak"])
            : null,
      );
  }

  Map<String, dynamic> toJson() => {
        'score1': score1,
        'score2': score2,
        'tieBreak': tieBreak?.toJson(),
      };
}

class TennisTieBreakScoreData {
  late String? score1;
  late String? score2;

  TennisTieBreakScoreData({
    required this.score1,
    required this.score2,
  });

  factory TennisTieBreakScoreData.fromJson(Map<String, dynamic> json) =>
      TennisTieBreakScoreData(
        score1: json["score1"],
        score2: json["score2"],
      );

  Map<String, dynamic> toJson() => {
        'score1': score1,
        'score2': score2,
      };
}
