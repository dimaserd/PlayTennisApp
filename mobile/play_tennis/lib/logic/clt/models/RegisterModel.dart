class RegisterModel {
  late String email;
  late String name;
  late String surname;
  late String patronymic;
  late String phoneNumber;
  late String password;

  RegisterModel();

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'phoneNumber': phoneNumber,
        'password': password,
      };
}
