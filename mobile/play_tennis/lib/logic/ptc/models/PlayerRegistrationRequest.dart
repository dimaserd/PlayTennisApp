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
  late bool noCityOrCountryFilled;
  late String? cityOrCountry;

  PlayerRegistrationRequest();

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
        'noCityOrCountryFilled': noCityOrCountryFilled,
        'cityOrCountry': cityOrCountry,
      };
}
