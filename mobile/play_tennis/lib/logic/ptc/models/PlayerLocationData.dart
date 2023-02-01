import 'CityModel.dart';

class PlayerLocationData {
  late String? id;
  late CountryNameModel? country;
  late CityModel? city;

  PlayerLocationData({
    required this.id,
    required this.country,
    required this.city,
  });

  factory PlayerLocationData.fromJson(Map<String, dynamic> json) =>
      PlayerLocationData(
        id: json["id"],
        country: json["country"] != null
            ? CountryNameModel?.fromJson(json["country"])
            : null,
        city: json["city"] != null ? CityModel?.fromJson(json["city"]) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country?.toJson(),
        'city': city?.toJson(),
      };
}

class CountryNameModel {
  late String? name;
  late String? id;

  CountryNameModel({
    required this.name,
    required this.id,
  });

  factory CountryNameModel.fromJson(Map<String, dynamic> json) =>
      CountryNameModel(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
