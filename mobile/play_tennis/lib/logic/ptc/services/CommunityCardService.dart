import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class CommunityCardSimpleModel {
  late String? id;
  late String? name;
  late String? description;
  late String? telegramLink;

  CommunityCardSimpleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.telegramLink,
  });

  factory CommunityCardSimpleModel.fromJson(Map<String, dynamic> json) =>
      CommunityCardSimpleModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        telegramLink: json["telegramLink"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'telegramLink': telegramLink,
      };
}

class SearchCommunityCards {
  late String? q;
  late String? cityId;
  late int? count;
  late int offSet;

  SearchCommunityCards({
    required this.q,
    required this.cityId,
    required this.count,
    required this.offSet,
  });

  factory SearchCommunityCards.fromJson(Map<String, dynamic> json) =>
      SearchCommunityCards(
        q: json["q"],
        cityId: json["cityId"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'cityId': cityId,
        'count': count,
        'offSet': offSet,
      };
}

class CommunityCardService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/community-card/";
  CommunityCardService(this.networkService);

  Future<GetListResult<CommunityCardSimpleModel>> search(
      SearchCommunityCards model, Function(String) errorHandler) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
        '${baseUrl}search', bodyJson, errorHandler);

    try {
      var json = jsonDecode(responseBody);

      var result = GetListResult(
        totalCount: json["totalCount"],
        list: List<CommunityCardSimpleModel>.from(
          json["list"].map((x) => CommunityCardSimpleModel.fromJson(x)),
        ),
        count: json["count"],
        offSet: json["offSet"],
      );

      return result;
    } catch (e) {
      errorHandler(e.toString());
      return GetListResult(totalCount: 0, list: [], count: 0, offSet: 0);
    }
  }
}
