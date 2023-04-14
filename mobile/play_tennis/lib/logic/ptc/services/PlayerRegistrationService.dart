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

class AdvancedPlayerRegistration {
  late String? name;
  late String? surname;
  late String? phoneNumber;
  late String? ntrpRating;
  late String? password;
  late bool sex;
  late DateTime birthDate;
  late String? cityId;
  late String? countryId;
  late String? cityOrCountry;
  late bool noCityOrCountryFilled;
  late String? registrationSource;
  late String? aboutMe;

  AdvancedPlayerRegistration({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.ntrpRating,
    required this.password,
    required this.sex,
    required this.birthDate,
    required this.cityId,
    required this.countryId,
    required this.cityOrCountry,
    required this.noCityOrCountryFilled,
    required this.registrationSource,
    required this.aboutMe,
  });

  factory AdvancedPlayerRegistration.fromJson(Map<String, dynamic> json) =>
      AdvancedPlayerRegistration(
        name: json["name"],
        surname: json["surname"],
        phoneNumber: json["phoneNumber"],
        ntrpRating: json["ntrpRating"],
        password: json["password"],
        sex: json["sex"],
        birthDate: DateTime.parse(json["birthDate"]),
        cityId: json["cityId"],
        countryId: json["countryId"],
        cityOrCountry: json["cityOrCountry"],
        noCityOrCountryFilled: json["noCityOrCountryFilled"],
        registrationSource: json["registrationSource"],
        aboutMe: json["aboutMe"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'phoneNumber': phoneNumber,
        'ntrpRating': ntrpRating,
        'password': password,
        'sex': sex,
        'birthDate': birthDate.toIso8601String(),
        'cityId': cityId,
        'countryId': countryId,
        'cityOrCountry': cityOrCountry,
        'noCityOrCountryFilled': noCityOrCountryFilled,
        'registrationSource': registrationSource,
        'aboutMe': aboutMe,
      };
}

class PlayerRegistrationService {
  final NetworkService networkService;
  PlayerRegistrationService(this.networkService);

  Future<PlayerRegistrationResult> register(PlayerRegistrationRequest model) {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    return registerInner(
      model.email!,
      model.password!,
      "v1",
      bodyJson,
    );
  }

  Future<PlayerRegistrationResult> registerAdvanced(
      AdvancedPlayerRegistration model) {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    return registerInner(
      model.phoneNumber!,
      model.password!,
      "advanced",
      bodyJson,
    );
  }

  Future<BaseApiResponse> confirm() async {
    var responseBody = await networkService.postData(
        "/api/ptc/player/registration/advanced/confirm", "{}");
    var decoded = jsonDecode(responseBody);

    return BaseApiResponse.fromJson(decoded);
  }

  Future<PlayerRegistrationResult> registerInner(
    String login,
    String password,
    String version,
    String bodyJson,
  ) async {
    var responseBody = await networkService.postData(
        '/api/ptc/player/registration/$version', bodyJson);
    var decoded = jsonDecode(responseBody);

    var response = PlayerRegistrationResult.fromJson(decoded);

    if (response.succeeded) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedKeys.login, login);
      prefs.setString(SharedKeys.pass, password);
    }

    return response;
  }
}
