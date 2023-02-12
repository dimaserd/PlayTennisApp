class SearchCities {
  late String? countryId;
  late String? q;
  late int? count;
  late int offSet;

  SearchCities({
    required this.countryId,
    required this.q,
    required this.count,
    required this.offSet,
  });

  factory SearchCities.fromJson(Map<String, dynamic> json) => SearchCities(
        countryId: json["countryId"],
        q: json["q"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'countryId': countryId,
        'q': q,
        'count': count,
        'offSet': offSet,
      };
}
