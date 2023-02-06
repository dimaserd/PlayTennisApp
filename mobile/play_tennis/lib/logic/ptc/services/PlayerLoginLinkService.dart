import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../clt/consts/SharedKeys.dart';
import '../../core/NetworkService.dart';

class LoginByEmailOrPhoneNumber {
  late String? emailOrPhoneNumber;
  late String? password;
  late bool rememberMe;

  LoginByEmailOrPhoneNumber({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.rememberMe,
  });

  factory LoginByEmailOrPhoneNumber.fromJson(Map<String, dynamic> json) =>
      LoginByEmailOrPhoneNumber(
        emailOrPhoneNumber: json["emailOrPhoneNumber"],
        password: json["password"],
        rememberMe: json["rememberMe"],
      );

  Map<String, dynamic> toJson() => {
        'emailOrPhoneNumber': emailOrPhoneNumber,
        'password': password,
        'rememberMe': rememberMe,
      };
}

class CreateLoginLinkResult {
  late bool isSucceeded;
  late String? errorMessage;
  late String? loginId;
  late String? password;

  CreateLoginLinkResult({
    required this.isSucceeded,
    required this.errorMessage,
    required this.loginId,
    required this.password,
  });

  factory CreateLoginLinkResult.fromJson(Map<String, dynamic> json) =>
      CreateLoginLinkResult(
        isSucceeded: json["isSucceeded"],
        errorMessage: json["errorMessage"],
        loginId: json["loginId"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        'isSucceeded': isSucceeded,
        'errorMessage': errorMessage,
        'loginId': loginId,
        'password': password,
      };
}

class PlayerLoginLinkService {
  final NetworkService networkService;

  PlayerLoginLinkService(this.networkService);

  Future<CreateLoginLinkResult> createLoginLink(
    Function(String) onError,
  ) async {
    var prefs = await SharedPreferences.getInstance();

    var model = LoginByEmailOrPhoneNumber(
      emailOrPhoneNumber: prefs.getString(SharedKeys.login),
      password: prefs.getString(SharedKeys.pass),
      rememberMe: true,
    );

    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var response = await networkService.postDataInner(
        'api/ptc/player-login/link/create', bodyJson, onError);

    if (response == null) {
      return CreateLoginLinkResult(
        errorMessage: "Ссылка для авторизации не была получена c серверf",
        isSucceeded: false,
        loginId: null,
        password: null,
      );
    }

    var decoded = jsonDecode(response.body);

    return CreateLoginLinkResult.fromJson(decoded);
  }
}
