import '../CityModel.dart';
import '../PlayerModel.dart';

class GameRequestDetailedModel {
  late String? id;
  late PlayerModel? author;
  late DateTime matchDateUtc;
  late String? description;
  late CityModel? city;
  late String? countryId;
  late bool hasMyRespond;
  late int respondsCount;

  GameRequestDetailedModel({
    required this.id,
    required this.author,
    required this.matchDateUtc,
    required this.description,
    required this.city,
    required this.countryId,
    required this.hasMyRespond,
    required this.respondsCount,
  });

  factory GameRequestDetailedModel.fromJson(Map<String, dynamic> json) =>
      GameRequestDetailedModel(
        id: json["id"],
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        matchDateUtc: DateTime.parse(json["matchDateUtc"]),
        description: json["description"],
        city: json["city"] != null ? CityModel?.fromJson(json["city"]) : null,
        countryId: json["countryId"],
        hasMyRespond: json["hasMyRespond"],
        respondsCount: json["respondsCount"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author?.toJson(),
        'matchDateUtc': matchDateUtc,
        'description': description,
        'city': city?.toJson(),
        'countryId': countryId,
        'hasMyRespond': hasMyRespond,
        'respondsCount': respondsCount,
      };
}
