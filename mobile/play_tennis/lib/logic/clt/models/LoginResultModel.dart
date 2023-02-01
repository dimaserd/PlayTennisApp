class LoginResultModel {
  late LoginErrorType? errorType;
  late String? errorMessage;
  late bool succeeded;

  LoginResultModel({
    required this.errorType,
    required this.errorMessage,
    required this.succeeded,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) =>
      new LoginResultModel(
        errorType: LoginErrorTypeDartJsonGenerator.getFromStringOrNull(
            json["errorType"]),
        errorMessage: json["errorMessage"],
        succeeded: json["succeeded"],
      );

  Map<String, dynamic> toJson() => {
        'errorType': errorType,
        'errorMessage': errorMessage,
        'succeeded': succeeded,
      };
}

enum LoginErrorType {
  Error,
  ModelNotValid,
  AlreadyAuthenticated,
  UnSuccessfulAttempt,
  EmailNotConfirmed,
  UserDeactivated
}

class LoginErrorTypeDartJsonGenerator {
  static getFromString(String value) {
    return LoginErrorType.values
        .firstWhere((e) => e.toString() == 'LoginErrorType.' + value);
  }

  static getFromStringOrNull(String? value) {
    return value == null
        ? null
        : LoginErrorTypeDartJsonGenerator.getFromString(value);
  }
}
