import 'dart:convert';
import 'package:play_tennis/logic/clt/consts/SharedKeys.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/clt/models/LoginResultModel.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        MainState.isAuthorized = true;
        AppServices.appNotificationTokenService.isAuthorizedHandler();
        return true;
      }

      prefs.remove(SharedKeys.login);
      prefs.remove(SharedKeys.pass);

      MainState.isAuthorized = false;
      return false;
    }

    MainState.isAuthorized = true;
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

    var decoded = jsonDecode(responseBody);
    var result = LoginResultModel.fromJson(decoded);

    MainState.isAuthorized = result.succeeded;

    if (result.succeeded) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedKeys.login, emailOrPhoneNumber);
      prefs.setString(SharedKeys.pass, password);
      AppServices.appNotificationTokenService.isAuthorizedHandler();
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
    var result = CurrentLoginData.fromJson(json);

    MainState.isAuthorized = result.isAuthenticated;

    return result;
  }
}
