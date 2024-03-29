import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class FirebaseTokenModel {
  late String? token;

  FirebaseTokenModel({
    required this.token,
  });

  factory FirebaseTokenModel.fromJson(Map<String, dynamic> json) =>
      FirebaseTokenModel(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}

class FlutterNotificationAppTokenService {
  final NetworkService networkService;

  bool isAuthorized = false;
  String? appInstanceToken;

  FlutterNotificationAppTokenService(this.networkService);

  Future<BaseApiResponse> updateAppToken(String token) async {
    var model = FirebaseTokenModel(token: token);

    var bodyJson = jsonEncode(model.toJson());
    var response = await networkService.postData(
        '/api/Client/Modifiers/FlutterApp', bodyJson);

    try {
      var json = jsonDecode(response);

      return BaseApiResponse.fromJson(json);
    } catch (e) {
      print("Произошла ошибка при привязке токена");
      return BaseApiResponse(isSucceeded: false, message: "Произошла ошибка");
    }
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
        print(value.message);
      },
    );
  }
}
