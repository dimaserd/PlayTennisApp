import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/ResponseForGameRequestIdModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/CreateGameRequest.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/SearchGameRequestResponses.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/SearchGameRequests.dart';

class GameRequestsService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/game-request/";
  GameRequestsService(this.networkService);

  Future<GetListResult<GameRequestSimpleModel>> search(
    SearchGameRequests model,
    Function(String) errorHandler,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
      '${baseUrl}search',
      bodyJson,
      errorHandler,
    );

    try {
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
    } catch (e) {
      errorHandler(e.toString());
      return GetListResult(totalCount: 0, list: [], count: 0, offSet: 0);
    }
  }

  Future<GameRequestDetailedModel?> getById(
    String id,
    Function(String) errorHandler,
  ) async {
    var response = await networkService.getDataInner(
      '${baseUrl}getById/$id',
      errorHandler,
    );

    if (response == "null") {
      return null;
    }

    try {
      var json = jsonDecode(response!);

      return GameRequestDetailedModel.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return null;
    }
  }

  Future<GetListResult<GameRequestResponseSimpleModel>> searchResponses(
    SearchGameRequestResponses model,
    Function(String) onError,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
      '${baseUrl}responses/search',
      bodyJson,
      onError,
    );

    try {
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
    } catch (e) {
      onError(e.toString());
      return GetListResult(
        count: 0,
        list: [],
        totalCount: 0,
        offSet: 0,
      );
    }
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
    ResponseForGameRequestIdModel model,
    Function(String) errorHandler,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
      '${baseUrl}responses/accept',
      bodyJson,
      errorHandler,
    );

    try {
      var json = jsonDecode(responseBody);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return BaseApiResponse(
        isSucceeded: false,
        message: "Произошла ошибка при принятии заявки",
      );
    }
  }

  Future<BaseApiResponse> declineResponse(
    ResponseForGameRequestIdModel model,
    Function(String) errorHandler,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
      '${baseUrl}responses/decline',
      bodyJson,
      errorHandler,
    );

    try {
      var json = jsonDecode(responseBody);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return BaseApiResponse(
        isSucceeded: false,
        message: "Произошла ошибка при отклонении заявки",
      );
    }
  }

  Future<BaseApiResponse> respond(
    String id,
    Function(String) errorHandler,
  ) async {
    var responseBody = await networkService.postDataV2(
      '${baseUrl}Respond/$id',
      "{}",
      errorHandler,
    );

    try {
      var json = jsonDecode(responseBody);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return BaseApiResponse(
        isSucceeded: false,
        message: "Произошла ошибка при ответе на заявку",
      );
    }
  }

  Future<BaseApiResponse> remove(String id) async {
    var responseBody =
        await networkService.postData('${baseUrl}Remove/$id', "{}");

    var json = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(json);
  }
}
