class ResponseForGameRequestIdModel {
  late String? gameRequestId;
  late String? playerId;

  ResponseForGameRequestIdModel({
    required this.gameRequestId,
    required this.playerId,
  });

  factory ResponseForGameRequestIdModel.fromJson(Map<String, dynamic> json) =>
      ResponseForGameRequestIdModel(
        gameRequestId: json["gameRequestId"],
        playerId: json["playerId"],
      );

  Map<String, dynamic> toJson() => {
        'gameRequestId': gameRequestId,
        'playerId': playerId,
      };
}
