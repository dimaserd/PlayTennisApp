import 'dart:convert';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';
import '../models/PlayerData.dart';
import '../models/PlayerLocationData.dart';
import '../models/PlayerModel.dart';
import '../models/SearchPlayersRequest.dart';
import '../models/players/UpdateDataByPlayerRequest.dart';

class PlayerService {
  final NetworkService networkService;
  PlayerService(this.networkService);

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
}
