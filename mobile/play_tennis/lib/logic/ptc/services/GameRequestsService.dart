import 'dart:convert';
import '/logic/ptc/models/game-requests/CreateGameRequest.dart';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';
import '../models/game-requests/AcceptGameRequestResponse.dart';
import '../models/game-requests/GameRequestDetailedModel.dart';
import '../models/game-requests/GameRequestResponseSimpleModel.dart';
import '../models/game-requests/GameRequestSimpleModel.dart';
import '../models/game-requests/SearchGameRequestResponses.dart';
import '../models/game-requests/SearchGameRequests.dart';

class GameRequestsService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/game-request/";
  GameRequestsService(this.networkService);

  Future<GetListResult<GameRequestSimpleModel>> search(
      SearchGameRequests model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}search', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<GameRequestSimpleModel>.from(
        json["list"].map((x) => GameRequestSimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }

  Future<GameRequestDetailedModel?> getById(String id) async {
    var response = await networkService.getData('${baseUrl}getById/$id');

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return GameRequestDetailedModel.fromJson(json);
  }

  Future<GetListResult<GameRequestResponseSimpleModel>> searchResponses(
      SearchGameRequestResponses model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}responses/search', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<GameRequestResponseSimpleModel>.from(
        json["list"].map((x) => GameRequestResponseSimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }

  Future<BaseApiResponse> create(CreateGameRequest model) async {
    var map = model.toJson();

    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}Create', bodyJson);

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }

  Future<BaseApiResponse> acceptResponse(
      AcceptGameRequestResponse model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}responses/accept', bodyJson);

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }

  Future<BaseApiResponse> respond(String id) async {
    var responseBody =
        await networkService.postData('${baseUrl}Respond/$id', "{}");

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }

  Future<BaseApiResponse> remove(String id) async {
    var responseBody =
        await networkService.postData('${baseUrl}Remove/$id', "{}");

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }
}
