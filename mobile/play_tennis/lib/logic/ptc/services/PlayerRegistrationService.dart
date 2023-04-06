import 'dart:convert';
import 'package:play_tennis/logic/clt/consts/SharedKeys.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/PlayerRegistrationRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerRegistrationResult {
  late bool succeeded;
  late String? message;
  late String? playerId;

  PlayerRegistrationResult({
    required this.succeeded,
    required this.message,
    required this.playerId,
  });

  factory PlayerRegistrationResult.fromJson(Map<String, dynamic> json) =>
      PlayerRegistrationResult(
        succeeded: json["succeeded"],
        message: json["message"],
        playerId: json["playerId"],
      );

  Map<String, dynamic> toJson() => {
        'succeeded': succeeded,
        'message': message,
        'playerId': playerId,
      };
}

class PlayerRegistrationService {
  final NetworkService networkService;
  PlayerRegistrationService(this.networkService);

  Future<PlayerRegistrationResult> register(
      PlayerRegistrationRequest model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postData(
        '/api/ptc/player/registration/v1', bodyJson);
    var decoded = jsonDecode(responseBody);

    var response = PlayerRegistrationResult.fromJson(decoded);

    if (response.succeeded) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedKeys.login, model.email!);
      prefs.setString(SharedKeys.pass, model.password!);
    }

    return response;
  }
}
