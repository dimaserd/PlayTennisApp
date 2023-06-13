import 'dart:convert';
import 'package:play_tennis/logic/clt/consts/SharedKeys.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class CreateLoginLinkResult
{
	late bool isSucceeded; 
	late String? errorMessage; 
	late String? linkId; 
	late String? password; 

	CreateLoginLinkResult({
		required this.isSucceeded,
		required this.errorMessage,
		required this.linkId,
		required this.password,
	});

	factory CreateLoginLinkResult.fromJson(Map<String, dynamic> json) =>
	 CreateLoginLinkResult(
		isSucceeded: json["isSucceeded"],
		errorMessage: json["errorMessage"],
		linkId: json["linkId"],
		password: json["password"],
	);

	Map<String, dynamic> toJson() => {
		'isSucceeded': isSucceeded,
		'errorMessage': errorMessage,
		'linkId': linkId,
		'password': password,
	};
}

class LoginLinkService {
  final NetworkService networkService;

  LoginLinkService(this.networkService);

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
        '/api/account/link/create', bodyJson, onError);

    if (response == null) {
      return CreateLoginLinkResult(
        errorMessage: "Ссылка для авторизации не была получена c сервера",
        isSucceeded: false,
        loginId: null,
        password: null,
      );
    }

    var decoded = jsonDecode(response.body);

    return CreateLoginLinkResult.fromJson(decoded);
  }
}
