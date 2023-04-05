import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class DeletePlayerService {
  final NetworkService networkService;

  DeletePlayerService(this.networkService);

  Future<BaseApiResponse> delete(String id) async {
    var response =
        await networkService.postData('/api/ptc/player/RemoveMe/$id', "{}");

    var json = jsonDecode(response);

    return BaseApiResponse.fromJson(json);
  }
}
