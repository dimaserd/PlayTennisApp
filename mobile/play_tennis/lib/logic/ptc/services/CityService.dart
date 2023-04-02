import 'dart:convert';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';

class CityDistrictModel {
  late String? id;
  late String? name;

  CityDistrictModel({
    required this.id,
    required this.name,
  });

  factory CityDistrictModel.fromJson(Map<String, dynamic> json) =>
      CityDistrictModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class CityService {
  final NetworkService networkService;
  CityService(this.networkService);

  Future<PublicTelegramChatForCityModel?> getById(
    String id,
    Function(String) onError,
  ) async {
    var response = await networkService.getDataInner(
      '/api/ptc/dlv/cities/$id/city-chat/cached',
      onError,
    );

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return PublicTelegramChatForCityModel.fromJson(json);
  }

  Future<List<CityDistrictModel>> getCityDistricts(
    String cityId,
    Function(String) onError,
  ) async {
    var response = await networkService.getDataInner(
      '/api/ptc/dlv/city-district/query/by-city/{cityId}/cached',
      onError,
    );

    if (response == "null") {
      return [];
    }

    var json = jsonDecode(response!);

    return json.map((x) => CityDistrictModel.fromJson(x));
  }
}
