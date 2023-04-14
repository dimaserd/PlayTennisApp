import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class DeletePlayerService {
  final NetworkService networkService;

  DeletePlayerService(this.networkService);

  Future<BaseApiResponse> delete(
      String id, Function(String) errorHandler) async {
    var response = await networkService.postDataV2(
        '/api/ptc/player/RemoveMe/$id', "{}", errorHandler);

    try {
      var json = jsonDecode(response);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return BaseApiResponse(isSucceeded: false, message: "Error");
    }
  }
}
