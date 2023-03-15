import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';

import '../PlayerModel.dart';
import '../cities/CityModel.dart';

class GameRequestDetailedModel {
  late String? id;
  late PlayerModel? author;
  late DateTime matchDateUtc;
  late String? matchDateString;
  late String? description;
  late CityModel? city;
  late String? countryId;
  late bool hasMyRespond;
  late int respondsCount;
  late RelativeToNowLocalDateDescription? toNowDateDescription;

  GameRequestDetailedModel({
    required this.id,
    required this.author,
    required this.matchDateUtc,
    required this.matchDateString,
    required this.description,
    required this.city,
    required this.countryId,
    required this.hasMyRespond,
    required this.respondsCount,
    required this.toNowDateDescription,
  });

  factory GameRequestDetailedModel.fromJson(Map<String, dynamic> json) =>
      GameRequestDetailedModel(
        id: json["id"],
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        matchDateUtc: DateTime.parse(json["matchDateUtc"]),
        matchDateString: json["matchDateString"],
        description: json["description"],
        city: json["city"] != null ? CityModel?.fromJson(json["city"]) : null,
        countryId: json["countryId"],
        hasMyRespond: json["hasMyRespond"],
        respondsCount: json["respondsCount"],
        toNowDateDescription: json["toNowDateDescription"] != null
            ? RelativeToNowLocalDateDescription?.fromJson(
                json["toNowDateDescription"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author?.toJson(),
        'matchDateUtc': matchDateUtc.toIso8601String(),
        'matchDateString': matchDateString,
        'description': description,
        'city': city?.toJson(),
        'countryId': countryId,
        'hasMyRespond': hasMyRespond,
        'respondsCount': respondsCount,
        'toNowDateDescription': toNowDateDescription?.toJson(),
      };
}
