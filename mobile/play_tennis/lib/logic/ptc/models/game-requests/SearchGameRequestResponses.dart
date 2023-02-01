class SearchGameRequestResponses {
  late String? q;
  late String? gameRequestId;
  late int? count;
  late int offSet;

  SearchGameRequestResponses({
    required this.q,
    required this.gameRequestId,
    required this.count,
    required this.offSet,
  });

  factory SearchGameRequestResponses.fromJson(Map<String, dynamic> json) =>
      SearchGameRequestResponses(
        q: json["q"],
        gameRequestId: json["gameRequestId"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'gameRequestId': gameRequestId,
        'count': count,
        'offSet': offSet,
      };
}
