class SearchGameRequests {
  late String? q;
  late String? countryId;
  late String? cityId;
  late bool showMine;
  late int? count;
  late int offSet;

  SearchGameRequests({
    required this.q,
    required this.countryId,
    required this.cityId,
    required this.showMine,
    required this.count,
    required this.offSet,
  });

  factory SearchGameRequests.fromJson(Map<String, dynamic> json) =>
      SearchGameRequests(
        q: json["q"],
        countryId: json["countryId"],
        cityId: json["cityId"],
        showMine: json["showMine"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'countryId': countryId,
        'cityId': cityId,
        'showMine': showMine,
        'count': count,
        'offSet': offSet,
      };
}
