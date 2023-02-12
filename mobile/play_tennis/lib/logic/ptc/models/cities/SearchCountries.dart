class SearchCountries {
  late String? q;
  late int? count;
  late int offSet;

  SearchCountries({
    required this.q,
    required this.count,
    required this.offSet,
  });

  factory SearchCountries.fromJson(Map<String, dynamic> json) =>
      SearchCountries(
        q: json["q"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'count': count,
        'offSet': offSet,
      };
}
