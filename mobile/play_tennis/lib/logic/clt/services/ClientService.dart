import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class ClientService {
  final NetworkService networkService;
  ClientService(this.networkService);

  Future<BaseApiResponse> updatePhoto(int fileId) async {
    var response = await networkService.postData(
        '/api/Client/Avatar/Update?fileId=$fileId', "{}");
    var json = jsonDecode(response);
    return BaseApiResponse.fromJson(json);
  }

  Future<SettingsApplication?> settingsApplication(String url) async {
    var response = await networkService.getData(url);
    if (response == null) {
      return null;
    }
    var json = jsonDecode(response);
    return SettingsApplication.fromJson(json);
    } 
}
