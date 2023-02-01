class AcceptGameRequestResponse {
  late String? gameRequestId;
  late String? playerId;

  AcceptGameRequestResponse({
    required this.gameRequestId,
    required this.playerId,
  });

  factory AcceptGameRequestResponse.fromJson(Map<String, dynamic> json) =>
      new AcceptGameRequestResponse(
        gameRequestId: json["gameRequestId"],
        playerId: json["playerId"],
      );

  Map<String, dynamic> toJson() => {
        'gameRequestId': gameRequestId,
        'playerId': playerId,
      };
}
