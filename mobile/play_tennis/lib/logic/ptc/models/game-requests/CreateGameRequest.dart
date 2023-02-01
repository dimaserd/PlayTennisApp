class CreateGameRequest {
  late String? countryId;
  late String? cityId;
  late DateTime matchDateUtc;
  late String? description;

  CreateGameRequest({
    required this.countryId,
    required this.cityId,
    required this.matchDateUtc,
    required this.description,
  });

  factory CreateGameRequest.fromJson(Map<String, dynamic> json) =>
      CreateGameRequest(
        countryId: json["countryId"],
        cityId: json["cityId"],
        matchDateUtc: DateTime.parse(json["matchDateUtc"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        'countryId': countryId,
        'cityId': cityId,
        'matchDateUtc': matchDateUtc.toIso8601String(),
        'description': description,
      };
}
