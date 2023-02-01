class CurrentLoginData {
  late bool isAuthenticated;
  late String? userId;
  late String? email;
  late List<String> roles;
  late int? avatarFileId;
  late String? name;
  late String? surname;
  late String? patronymic;

  CurrentLoginData({
    required this.isAuthenticated,
    required this.userId,
    required this.email,
    required this.roles,
    required this.avatarFileId,
    required this.name,
    required this.surname,
    required this.patronymic,
  });

  factory CurrentLoginData.fromJson(Map<String, dynamic> json) =>
      CurrentLoginData(
        isAuthenticated: json["isAuthenticated"],
        userId: json["userId"],
        email: json["email"],
        roles: List<String>.from(json["roles"]),
        avatarFileId: json["avatarFileId"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
      );

  Map<String, dynamic> toJson() => {
        'isAuthenticated': isAuthenticated,
        'userId': userId,
        'email': email,
        'roles': roles,
        'avatarFileId': avatarFileId,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
      };
}
