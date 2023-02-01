class UpdateDataByPlayerRequest {
  late String? name;
  late String? surname;
  late String? patronymic;
  late String? aboutMe;
  late DateTime birthDate;
  late bool sex;

  UpdateDataByPlayerRequest({
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.aboutMe,
    required this.birthDate,
    required this.sex,
  });

  factory UpdateDataByPlayerRequest.fromJson(Map<String, dynamic> json) =>
      UpdateDataByPlayerRequest(
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        aboutMe: json["aboutMe"],
        birthDate: DateTime.parse(json["birthDate"]),
        sex: json["sex"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'aboutMe': aboutMe,
        'birthDate': birthDate.toIso8601String(),
        'sex': sex,
      };
}
