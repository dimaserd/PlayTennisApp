import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../clt/consts/SharedKeys.dart';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';
import '../models/PlayerRegistrationRequest.dart';

class PlayerRegistrationService {
  final NetworkService networkService;
  PlayerRegistrationService(this.networkService);

  Future<GenericBaseApiResponse<String>> register(
      PlayerRegistrationRequest model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('/api/ptc/player/Register', bodyJson);
    var decoded = jsonDecode(responseBody);

    var baseApiResponse = BaseApiResponse.fromJson(decoded);

    var result =
        baseApiResponse.isSucceeded ? decoded["responseObject"].toString() : "";

    if (baseApiResponse.isSucceeded) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedKeys.login, model.email!);
      prefs.setString(SharedKeys.pass, model.password!);
    }

    return GenericBaseApiResponse<String>(baseApiResponse, result);
  }
}
