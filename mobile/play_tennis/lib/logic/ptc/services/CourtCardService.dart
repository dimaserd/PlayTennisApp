import 'dart:convert';

import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class SearchCourtCards {
  late String? q;
  late String? cityId;
  late int? count;
  late int offSet;

  SearchCourtCards({
    required this.q,
    required this.cityId,
    required this.count,
    required this.offSet,
  });

  factory SearchCourtCards.fromJson(Map<String, dynamic> json) =>
      SearchCourtCards(
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

class CourtCardSimpleModel {
  late String? id;
  late String? name;
  late String? description;
  late String? address;
  late String? phoneNumber;
  late String? webSite;
  late double yandexMapsLatitude;
  late double yandexMapsLongitude;
  late String? yandexMapsOrganizationId;
  late String? yandexMapsAppLink;

  CourtCardSimpleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phoneNumber,
    required this.webSite,
    required this.yandexMapsLatitude,
    required this.yandexMapsLongitude,
    required this.yandexMapsOrganizationId,
    required this.yandexMapsAppLink,
  });

  factory CourtCardSimpleModel.fromJson(Map<String, dynamic> json) =>
      CourtCardSimpleModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        webSite: json["webSite"],
        yandexMapsLatitude: json["yandexMapsLatitude"],
        yandexMapsLongitude: json["yandexMapsLongitude"],
        yandexMapsOrganizationId: json["yandexMapsOrganizationId"],
        yandexMapsAppLink: json["yandexMapsAppLink"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'address': address,
        'phoneNumber': phoneNumber,
        'webSite': webSite,
        'yandexMapsLatitude': yandexMapsLatitude,
        'yandexMapsLongitude': yandexMapsLongitude,
        'yandexMapsOrganizationId': yandexMapsOrganizationId,
        'yandexMapsAppLink': yandexMapsAppLink,
      };
}

class CourtCardService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/court-card/";
  CourtCardService(this.networkService);

  Future<GetListResult<CourtCardSimpleModel>> search(
      SearchCourtCards model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}search', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<CourtCardSimpleModel>.from(
        json["list"].map((x) => CourtCardSimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }
}
