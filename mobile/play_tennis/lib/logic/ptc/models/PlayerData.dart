class PlayerData {
  late String? aboutMe;
  late bool sex;
  late bool dataFilled;
  late String? name;
  late String? surname;
  late String? patronymic;
  late String? phoneNumber;
  late String? email;
  late int? avatarFileId;
  late String? ntrpRating;
  late double rating;
  late bool emailConfirmed;
  late bool accountConfirmed;
  late int? telegramUserId;
  late String? telegramUserName;
  late String? cityId;
  late String? countryId;
  late DateTime birthDate;
  late DateTime createdOn;

  PlayerData({
    required this.aboutMe,
    required this.sex,
    required this.dataFilled,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.phoneNumber,
    required this.email,
    required this.avatarFileId,
    required this.ntrpRating,
    required this.rating,
    required this.emailConfirmed,
    required this.accountConfirmed,
    required this.telegramUserId,
    required this.telegramUserName,
    required this.cityId,
    required this.countryId,
    required this.birthDate,
    required this.createdOn,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) => new PlayerData(
        aboutMe: json["aboutMe"],
        sex: json["sex"],
        dataFilled: json["dataFilled"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        avatarFileId: json["avatarFileId"],
        ntrpRating: json["ntrpRating"],
        rating: json["rating"],
        emailConfirmed: json["emailConfirmed"],
        accountConfirmed: json["accountConfirmed"],
        telegramUserId: json["telegramUserId"],
        telegramUserName: json["telegramUserName"],
        cityId: json["cityId"],
        countryId: json["countryId"],
        birthDate: DateTime.parse(json["birthDate"]),
        createdOn: DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        'aboutMe': aboutMe,
        'sex': sex,
        'dataFilled': dataFilled,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'phoneNumber': phoneNumber,
        'email': email,
        'avatarFileId': avatarFileId,
        'ntrpRating': ntrpRating,
        'rating': rating,
        'emailConfirmed': emailConfirmed,
        'accountConfirmed': accountConfirmed,
        'telegramUserId': telegramUserId,
        'telegramUserName': telegramUserName,
        'cityId': cityId,
        'countryId': countryId,
        'birthDate': birthDate,
        'createdOn': createdOn,
      };
}
