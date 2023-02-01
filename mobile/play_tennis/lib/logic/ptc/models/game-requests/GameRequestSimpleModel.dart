import '../PlayerModel.dart';

class GameRequestSimpleModel {
  late String? id;
  late PlayerModel? author;
  late DateTime matchDateUtc;
  late String? description;
  late bool hasMyRespond;
  late int respondsCount;

  GameRequestSimpleModel({
    required this.id,
    required this.author,
    required this.matchDateUtc,
    required this.description,
    required this.hasMyRespond,
    required this.respondsCount,
  });

  factory GameRequestSimpleModel.fromJson(Map<String, dynamic> json) =>
      new GameRequestSimpleModel(
        id: json["id"],
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        matchDateUtc: DateTime.parse(json["matchDateUtc"]),
        description: json["description"],
        hasMyRespond: json["hasMyRespond"],
        respondsCount: json["respondsCount"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author?.toJson(),
        'matchDateUtc': matchDateUtc,
        'description': description,
        'hasMyRespond': hasMyRespond,
        'respondsCount': respondsCount,
      };
}
