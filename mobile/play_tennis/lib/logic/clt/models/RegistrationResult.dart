class RegistrationResult {
  late bool succeeded;
  late String? errorMessage;
  late RegistrationErrorResultType? errorType;
  late RegisteredUser? registeredUser;

  RegistrationResult({
    required this.succeeded,
    required this.errorMessage,
    required this.errorType,
    required this.registeredUser,
  });

  factory RegistrationResult.fromJson(Map<String, dynamic> json) =>
      RegistrationResult(
        succeeded: json["succeeded"],
        errorMessage: json["errorMessage"],
        errorType:
            RegistrationErrorResultTypeDartJsonGenerator.getFromStringOrNull(
                json["errorType"]),
        registeredUser: json["registeredUser"] != null
            ? RegisteredUser?.fromJson(json["registeredUser"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'succeeded': succeeded,
        'errorMessage': errorMessage,
        'errorType': errorType,
        'registeredUser': registeredUser?.toJson(),
      };
}

enum RegistrationErrorResultType {
  RegistrationNotEnabled,
  AlreadyAuthenticated,
  EmailShouldBeSet,
  PhoneNumberShouldBeSet,
  UserWithThisEmailAlreadyExists,
  UserWithThisPhoneAlreadyExists,
  UserManagerError,
  ClientAddingError,
  UnAcceptablePassword
}

class RegistrationErrorResultTypeDartJsonGenerator {
  static getFromString(String value) {
    return RegistrationErrorResultType.values.firstWhere(
        (e) => e.toString() == 'RegistrationErrorResultType.' + value);
  }

  static getFromStringOrNull(String? value) {
    return value == null
        ? null
        : RegistrationErrorResultTypeDartJsonGenerator.getFromString(value);
  }
}

class RegisteredUser {
  late String? id;
  late String? phoneNumber;
  late String? email;

  RegisteredUser({
    required this.id,
    required this.phoneNumber,
    required this.email,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) => RegisteredUser(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'email': email,
      };
}
