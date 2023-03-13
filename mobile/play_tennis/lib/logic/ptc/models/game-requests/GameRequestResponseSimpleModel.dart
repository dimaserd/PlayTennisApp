import '../PlayerModel.dart';

class GameRequestResponseSimpleModel {
  late PlayerModel? author;
  late DateTime createdOnUtc;
  late bool acceptedByRequestAuthor;
  late bool declinedByRequestAuthor;

  GameRequestResponseSimpleModel({
    required this.author,
    required this.createdOnUtc,
    required this.acceptedByRequestAuthor,
    required this.declinedByRequestAuthor,
  });

  factory GameRequestResponseSimpleModel.fromJson(Map<String, dynamic> json) =>
      GameRequestResponseSimpleModel(
        author: json["author"] != null
            ? PlayerModel?.fromJson(json["author"])
            : null,
        createdOnUtc: DateTime.parse(json["createdOnUtc"]),
        acceptedByRequestAuthor: json["acceptedByRequestAuthor"],
        declinedByRequestAuthor: json["declinedByRequestAuthor"],
      );

  Map<String, dynamic> toJson() => {
        'author': author?.toJson(),
        'createdOnUtc': createdOnUtc.toIso8601String(),
        'acceptedByRequestAuthor': acceptedByRequestAuthor,
        'declinedByRequestAuthor': declinedByRequestAuthor,
      };
}
