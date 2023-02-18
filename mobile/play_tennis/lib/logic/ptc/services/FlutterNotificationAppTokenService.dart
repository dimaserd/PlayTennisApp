import 'dart:convert';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';

class FlutterNotificationAppTokenService {
  final NetworkService networkService;

  bool isAuthorized = false;
  String? appInstanceToken;

  FlutterNotificationAppTokenService(this.networkService);

  Future<BaseApiResponse> updateAppToken(String token) async {
    var response = await networkService.postData(
        '/api/ptc/player/FlutterAppToken/Update/$token', "{}");

    var json = jsonDecode(response);

    return BaseApiResponse.fromJson(json);
  }

  addToken(String token) {
    appInstanceToken = token;
    tryUpdateToken();
  }

  isAuthorizedHandler() {
    isAuthorized = true;
    tryUpdateToken();
  }

  tryUpdateToken() {
    if (!isAuthorized) {
      return;
    }

    if (appInstanceToken == null) {
      return;
    }

    updateAppToken(appInstanceToken!).then(
      (value) {
        print("Token updated");
        print(value.message);
      },
    );
  }
}
