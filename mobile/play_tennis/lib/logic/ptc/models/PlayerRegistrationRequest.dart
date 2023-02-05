class PlayerRegistrationRequest {
  late String? email;
  late String? name;
  late String? surname;
  late String? patronymic;
  late String? phoneNumber;
  late String? password;
  late String? aboutMe;
  late String? cityId;
  late String? countryId;
  late String? ntrpRating;
  late bool sex;
  late DateTime birthDate;
  late bool birthDateNotSet;
  late bool noCityOrCountryFilled;
  late String? cityOrCountry;
  late bool noEmail;
  late bool useRegistrationLink;
  late String? registrationLinkId;
  late String? registrationSource;

  PlayerRegistrationRequest({
    required this.email,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.phoneNumber,
    required this.password,
    required this.aboutMe,
    required this.cityId,
    required this.countryId,
    required this.ntrpRating,
    required this.sex,
    required this.birthDate,
    required this.birthDateNotSet,
    required this.noCityOrCountryFilled,
    required this.cityOrCountry,
    required this.noEmail,
    required this.useRegistrationLink,
    required this.registrationLinkId,
    required this.registrationSource,
  });

  factory PlayerRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      PlayerRegistrationRequest(
        email: json["email"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        aboutMe: json["aboutMe"],
        cityId: json["cityId"],
        countryId: json["countryId"],
        ntrpRating: json["ntrpRating"],
        sex: json["sex"],
        birthDate: DateTime.parse(json["birthDate"]),
        birthDateNotSet: json["birthDateNotSet"],
        noCityOrCountryFilled: json["noCityOrCountryFilled"],
        cityOrCountry: json["cityOrCountry"],
        noEmail: json["noEmail"],
        useRegistrationLink: json["useRegistrationLink"],
        registrationLinkId: json["registrationLinkId"],
        registrationSource: json["registrationSource"],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'phoneNumber': phoneNumber,
        'password': password,
        'aboutMe': aboutMe,
        'cityId': cityId,
        'countryId': countryId,
        'ntrpRating': ntrpRating,
        'sex': sex,
        'birthDate': birthDate.toIso8601String(),
        'birthDateNotSet': birthDateNotSet,
        'noCityOrCountryFilled': noCityOrCountryFilled,
        'cityOrCountry': cityOrCountry,
        'noEmail': noEmail,
        'useRegistrationLink': useRegistrationLink,
        'registrationLinkId': registrationLinkId,
        'registrationSource': registrationSource,
      };
}
