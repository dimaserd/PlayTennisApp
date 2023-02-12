class CountrySimpleModel {
  late String? name;
  late String? id;
  late int citiesCount;

  CountrySimpleModel({
    required this.name,
    required this.id,
    required this.citiesCount,
  });

  factory CountrySimpleModel.fromJson(Map<String, dynamic> json) =>
      CountrySimpleModel(
        name: json["name"],
        id: json["id"],
        citiesCount: json["citiesCount"],
      );

  factory CountrySimpleModel.fromJsonDynamic(dynamic json) =>
      CountrySimpleModel(
        name: json["name"],
        id: json["id"],
        citiesCount: json["citiesCount"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'citiesCount': citiesCount,
      };
}
