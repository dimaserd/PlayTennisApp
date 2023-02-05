import '../PlayerModel.dart';

class GameRequestResponseSimpleModel {
  late PlayerModel? author;
  late DateTime createdOnUtc;
  late bool acceptedByRequestAuthor;

  GameRequestResponseSimpleModel({
    required this.author,
    required this.createdOnUtc,
    required this.acceptedByRequestAuthor,
  });

  factory GameRequestResponseSimpleModel.fromJson(Map<String, dynamic> json) =>
      GameRequestResponseSimpleModel(
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        createdOnUtc: DateTime.parse(json["createdOnUtc"]),
        acceptedByRequestAuthor: json["acceptedByRequestAuthor"],
      );

  Map<String, dynamic> toJson() => {
        'author': author?.toJson(),
        'createdOnUtc': createdOnUtc,
        'acceptedByRequestAuthor': acceptedByRequestAuthor,
      };
}
