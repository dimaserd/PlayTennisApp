import 'LoginResultModel.dart';
import 'RegistrationResult.dart';

class RegisterAndSignInResult {
  late RegistrationResult? registrationResult;
  late LoginResultModel? loginResult;

  RegisterAndSignInResult({
    required this.registrationResult,
    required this.loginResult,
  });

  factory RegisterAndSignInResult.fromJson(Map<String, dynamic> json) => RegisterAndSignInResult(
        registrationResult: json["registrationResult"] != null
            ? RegistrationResult?.fromJson(json["registrationResult"])
            : null,
        loginResult:
            json["loginResult"] != null ? LoginResultModel?.fromJson(json["loginResult"]) : null,
      );

  Map<String, dynamic> toJson() => {
        'registrationResult': registrationResult?.toJson(),
        'loginResult': loginResult?.toJson(),
      };
}
