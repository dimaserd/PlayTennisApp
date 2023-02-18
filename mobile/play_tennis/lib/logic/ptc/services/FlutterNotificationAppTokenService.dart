import 'dart:convert';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';

class FlutterNotificationAppTokenService {
  final NetworkService networkService;

  FlutterNotificationAppTokenService(this.networkService);

  Future<BaseApiResponse> updateCityAndCountryData(String token) async {
    var response = await networkService.postData(
        '/api/ptc/player/FlutterAppToken/Update/$token', "{}");

    var json = jsonDecode(response);

    return BaseApiResponse.fromJson(json);
  }
}
