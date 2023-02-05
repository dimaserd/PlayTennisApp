class PlayerModel {
  late String? id;
  late String? aboutMe;
  late bool sex;
  late bool dataFilled;
  late String? name;
  late String? surname;
  late String? patronymic;
  late String? phoneNumber;
  late String? email;
  late String? ntrpRating;
  late double rating;
  late int? telegramUserId;
  late String? telegramUserName;
  late bool emailConfirmed;
  late bool accountConfirmed;
  late int? avatarFileId;

  PlayerModel({
    required this.id,
    required this.aboutMe,
    required this.sex,
    required this.dataFilled,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.phoneNumber,
    required this.email,
    required this.ntrpRating,
    required this.rating,
    required this.telegramUserId,
    required this.telegramUserName,
    required this.emailConfirmed,
    required this.accountConfirmed,
    required this.avatarFileId,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        id: json["id"],
        aboutMe: json["aboutMe"],
        sex: json["sex"],
        dataFilled: json["dataFilled"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        ntrpRating: json["ntrpRating"],
        rating: json["rating"],
        telegramUserId: json["telegramUserId"],
        telegramUserName: json["telegramUserName"],
        emailConfirmed: json["emailConfirmed"],
        accountConfirmed: json["accountConfirmed"],
        avatarFileId: json["avatarFileId"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'aboutMe': aboutMe,
        'sex': sex,
        'dataFilled': dataFilled,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'phoneNumber': phoneNumber,
        'email': email,
        'ntrpRating': ntrpRating,
        'rating': rating,
        'telegramUserId': telegramUserId,
        'telegramUserName': telegramUserName,
        'emailConfirmed': emailConfirmed,
        'accountConfirmed': accountConfirmed,
        'avatarFileId': avatarFileId,
      };
}
