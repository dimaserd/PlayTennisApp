import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/NetworkService.dart';
import '../consts/SharedKeys.dart';
import '../models/BaseApiResponse.dart';
import '../models/CurrentLoginData.dart';
import '../models/LoginResultModel.dart';

class LoginService {
  final NetworkService networkService;
  LoginService(this.networkService);

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(SharedKeys.login);
    String? password = prefs.getString(SharedKeys.pass);

    if (email == null || password == null) {
      prefs.remove(SharedKeys.login);
      prefs.remove(SharedKeys.pass);
      await logOut();
      return false;
    }

    var loginResult = await login(email, password);

    if (!loginResult.succeeded) {
      if (loginResult.errorType == LoginErrorType.AlreadyAuthenticated) {
        return true;
      }

      prefs.remove(SharedKeys.login);
      prefs.remove(SharedKeys.pass);

      return false;
    }

    return true;
  }

  Future<LoginResultModel> login(
    String emailOrPhoneNumber,
    String password,
  ) async {
    Map data = {'emailOrPhoneNumber': emailOrPhoneNumber, 'password': password};

    //encode Map to JSON
    var bodyJson = jsonEncode(data);
    var responseBody =
        await networkService.postData('/api/account/login', bodyJson);

    print("LoginResult");
    print(responseBody);
    var decoded = jsonDecode(responseBody);
    var result = LoginResultModel.fromJson(decoded);

    if (result.succeeded) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedKeys.login, emailOrPhoneNumber);
      prefs.setString(SharedKeys.pass, password);
    }
    return result;
  }

  Future<BaseApiResponse> logOut() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(SharedKeys.login);
    prefs.remove(SharedKeys.pass);

    var response = await networkService.postData('/api/account/logout', "{}");
    var json = jsonDecode(response);
    return BaseApiResponse.fromJson(json);
  }

  Future<CurrentLoginData> getLoginData() async {
    var response = await networkService.getData('/api/account/user');

    var json = jsonDecode(response!);
    return CurrentLoginData.fromJson(json);
  }
}
