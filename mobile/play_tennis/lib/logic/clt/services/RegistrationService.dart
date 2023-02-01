import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/NetworkService.dart';
import '../consts/SharedKeys.dart';
import '../models/RegisterAndSignInResult.dart';
import '../models/RegisterModel.dart';
import '../models/RegistrationResult.dart';

class RegistrationService {
  final NetworkService networkService;
  RegistrationService(this.networkService);

  Future<RegistrationResult> register(RegisterModel model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('/api/account/Register', bodyJson);
    var decoded = jsonDecode(responseBody);
    var result = RegistrationResult.fromJson(decoded);

    if (result.succeeded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(SharedKeys.login, model.email);
      prefs.setString(SharedKeys.pass, model.password);
    }

    return result;
  }

  Future<RegisterAndSignInResult> registerAndSignIn(RegisterModel model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postData(
        '/api/account/RegisterAndSignIn', bodyJson);
    var decoded = jsonDecode(responseBody);
    var result = RegisterAndSignInResult.fromJson(decoded);

    if (result.loginResult!.succeeded && result.registrationResult!.succeeded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(SharedKeys.login, model.email);
      prefs.setString(SharedKeys.pass, model.password);
    }

    return result;
  }
}
