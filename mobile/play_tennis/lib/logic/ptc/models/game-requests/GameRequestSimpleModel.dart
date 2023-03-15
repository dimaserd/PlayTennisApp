import '../PlayerModel.dart';

class GameRequestSimpleModel {
  late String? id;
  late PlayerModel? author;
  late DateTime matchDateUtc;
  late String? matchDateString;
  late String? description;
  late bool hasMyRespond;
  late bool hasMyAcceptedRespond;
  late bool hasMyDeclinedRespond;
  late int respondsCount;
  late RelativeToNowLocalDateDescription? toNowDateDescription;

  GameRequestSimpleModel({
    required this.id,
    required this.author,
    required this.matchDateUtc,
    required this.matchDateString,
    required this.description,
    required this.hasMyRespond,
    required this.hasMyAcceptedRespond,
    required this.hasMyDeclinedRespond,
    required this.respondsCount,
    required this.toNowDateDescription,
  });

  factory GameRequestSimpleModel.fromJson(Map<String, dynamic> json) =>
      GameRequestSimpleModel(
        id: json["id"],
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        matchDateUtc: DateTime.parse(json["matchDateUtc"]),
        matchDateString: json["matchDateString"],
        description: json["description"],
        hasMyRespond: json["hasMyRespond"],
        hasMyAcceptedRespond: json["hasMyAcceptedRespond"],
        hasMyDeclinedRespond: json["hasMyDeclinedRespond"],
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
        'hasMyRespond': hasMyRespond,
        'hasMyAcceptedRespond': hasMyAcceptedRespond,
        'hasMyDeclinedRespond': hasMyDeclinedRespond,
        'respondsCount': respondsCount,
        'toNowDateDescription': toNowDateDescription?.toJson(),
      };
}

class RelativeToNowLocalDateDescription {
  late int dayDifference;
  late DateTime localDateTime;
  late String? localTimeString;

  RelativeToNowLocalDateDescription({
    required this.dayDifference,
    required this.localDateTime,
    required this.localTimeString,
  });

  factory RelativeToNowLocalDateDescription.fromJson(
          Map<String, dynamic> json) =>
      RelativeToNowLocalDateDescription(
        dayDifference: json["dayDifference"],
        localDateTime: DateTime.parse(json["localDateTime"]),
        localTimeString: json["localTimeString"],
      );

  Map<String, dynamic> toJson() => {
        'dayDifference': dayDifference,
        'localDateTime': localDateTime.toIso8601String(),
        'localTimeString': localTimeString,
      };
}
