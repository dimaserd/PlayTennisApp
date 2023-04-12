import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/logic/ptc/models/SearchPlayersRequest.dart';
import 'package:play_tennis/logic/ptc/models/players/UpdateDataByPlayerRequest.dart';

class UpdateCountryAndCityDataRequest {
  late String? countryId;
  late String? cityId;

  UpdateCountryAndCityDataRequest({
    required this.countryId,
    required this.cityId,
  });

  factory UpdateCountryAndCityDataRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCountryAndCityDataRequest(
        countryId: json["countryId"],
        cityId: json["cityId"],
      );

  Map<String, dynamic> toJson() => {
        'countryId': countryId,
        'cityId': cityId,
      };
}

class TelegramLinkResponse {
  late String? command;

  TelegramLinkResponse({
    required this.command,
  });

  factory TelegramLinkResponse.fromJson(Map<String, dynamic> json) =>
      TelegramLinkResponse(
        command: json["command"],
      );

  Map<String, dynamic> toJson() => {
        'command': command,
      };
}

class PlayerService {
  final NetworkService networkService;

  PlayerService(this.networkService);

  Future<BaseApiResponse> updateCityAndCountryData(
      UpdateCountryAndCityDataRequest model) async {
    Map<String, dynamic> map = model.toJson();
    String bodyJson = jsonEncode(map);

    var response = await networkService.postData(
        '/api/ptc/player/Data/City/Update', bodyJson);

    var json = jsonDecode(response);

    return BaseApiResponse.fromJson(json);
  }

  Future<GetListResult<PlayerModel>> search(SearchPlayersRequest model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('/api/ptc/player/search', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<PlayerModel>.from(
        json["list"].map((x) => PlayerModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }

  Future<BaseApiResponse> confirmEmail(String code) async {
    if (code.isEmpty) {
      return BaseApiResponse(isSucceeded: false, message: "Код не указан");
    }

    var responseBody = await networkService.postData(
        '/api/ptc/player/Data/Email/Confirm/$code', "{}");

    var json = jsonDecode(responseBody);

    var result = BaseApiResponse.fromJson(json);

    return result;
  }

  Future<PlayerModel?> getById(String id) async {
    var response = await networkService.getData('/api/ptc/player/GetById/$id');

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return PlayerModel.fromJson(json);
  }

  Future<PlayerData?> getData() async {
    var response = await networkService.getData('/api/ptc/player/Data/Get');

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return PlayerData.fromJson(json);
  }

  Future<BaseApiResponse> updateData(UpdateDataByPlayerRequest model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var response =
        await networkService.postData('/api/ptc/player/Data/Update', bodyJson);

    var json = jsonDecode(response);

    return BaseApiResponse.fromJson(json);
  }

  Future<PlayerLocationData?> getLocationData() async {
    var response =
        await networkService.getData('/api/ptc/player/Data/Location/Get');

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return PlayerLocationData.fromJson(json);
  }

  Future<GenericBaseApiResponse<TelegramLinkResponse>>
      createTelegramLink() async {
    var response = await networkService.postData(
        '/api/ptc/player/telegram/CreateLink', "{}");

    var json = jsonDecode(response);

    var result = BaseApiResponse.fromJson(json);

    return GenericBaseApiResponse(
      result,
      TelegramLinkResponse.fromJson(json["responseObject"]),
    );
  }
}
