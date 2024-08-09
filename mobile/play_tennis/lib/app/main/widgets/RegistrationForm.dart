import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/DatePickerInput.dart';
import 'package:play_tennis/app/main/widgets/Inputs/DropdownWidget.dart';
import 'package:play_tennis/app/main/widgets/Inputs/PasswordInput.dart';
import 'package:play_tennis/app/main/widgets/Inputs/PhoneNumberInput.dart';
import 'package:play_tennis/app/main/widgets/Inputs/TextInput.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerRegistrationRequest.dart';
import 'package:play_tennis/logic/ptc/services/PlayerRegistrationService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';

class RegistrationFormOptions {
  final bool isV2;
  final bool showSurname;
  final bool isAboutMeRequired;

  RegistrationFormOptions({
    required this.isV2,
    required this.showSurname,
    required this.isAboutMeRequired,
  });
}

class RegistrationForm extends StatefulWidget {
  final VoidCallback onLogin;
  final RegistrationFormOptions options;

  const RegistrationForm({
    super.key,
    required this.options,
    required this.onLogin,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool isRegistrationInProgress = false;
  int step = 0;

  DropdownWidgetItem? selectedSex;
  DropdownWidgetItem selectedNTRP = DropdownWidgetItem(
    label: "1.0",
    value: "1.0",
  );
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();
  final TextEditingController emailTextController = TextEditingController();

  final TextEditingController passTextController = TextEditingController();

  final TextEditingController nameTextController = TextEditingController();

  final TextEditingController surnameTextController = TextEditingController();

  final TextEditingController patronymicTextController =
      TextEditingController();

  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController aboutMeTextController = TextEditingController();

  final EdgeInsets padding = const EdgeInsets.only(
    top: 10,
    left: 20,
    right: 20,
  );

  late DateTime birthDate = DateTime.now();

  List<Widget> getFormWidgets() {
    if (isRegistrationInProgress) {
      return [
        const Loading(text: "Регистрируемся"),
      ];
    }

    if (step == 0) {
      return getFirstStepWidgets();
    }

    if (step == 1) {
      return getSecondStepWidgets();
    }

    return getThirdStepWidgets();
  }

  submitFirstStep() {
    if (!validateFirstStep()) {
      return;
    }

    setState(() {
      step = 1;
    });
  }

  bool validateFirstStep() {
    if (countryAndCitySelectController.country == null ||
        countryAndCitySelectController.city == null) {
      showError("Вы не указали страну или город");
      return false;
    }

    return true;
  }

  showError(String errorMessage) {
    BaseApiResponseUtils.showError(context, errorMessage);
  }

  submitSecondStep() {
    if (!validateSecondStep()) {
      return;
    }

    setState(() {
      step = 2;
    });
  }

  bool validateSecondStep() {
    if (surnameTextController.text == "") {
      showError("Вы не указали вашу фамилию");
      return false;
    }

    if (nameTextController.text == "") {
      showError("Вы не указали ваше имя");
      return false;
    }

    if (patronymicTextController.text == "" && widget.options.showSurname) {
      showError("Вы не указали ваше отчество");
      return false;
    }

    if (selectedSex == null) {
      showError("Вы не указали ваш пол");
      return false;
    }

    if (aboutMeTextController.text == "" && widget.options.isAboutMeRequired) {
      showError("Вы ничего не указали в разделе Обо мне");
      return false;
    }

    return true;
  }

  List<Widget> getThirdStepWidgets() {
    return [
      widget.options.isV2
          ? const SizedBox.shrink()
          : Padding(
              padding: padding,
              child: TextInput(
                labelText: "Адрес электронной почты",
                textController: emailTextController,
              ),
            ),
      Padding(
        padding: padding,
        child: PhoneNumberInput(
          labelText: "Номер телефона",
          textController: phoneTextController,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
        child: PasswordInput(
          textController: passTextController,
        ),
      ),
      getRegistrationBtn(),
      getBackBtn(),
    ];
  }

  List<Widget> getSecondStepWidgets() {
    return [
      Padding(
        padding: padding,
        child: TextInput(
          labelText: "Фамилия",
          textController: surnameTextController,
        ),
      ),
      Padding(
        padding: padding,
        child: TextInput(
          labelText: "Имя",
          textController: nameTextController,
        ),
      ),
      widget.options.showSurname
          ? Padding(
              padding: padding,
              child: TextInput(
                labelText: "Отчество",
                textController: patronymicTextController,
              ),
            )
          : const SizedBox.shrink(),
      Padding(
        padding: padding,
        child: DropdownWidget(
          label: "Пол",
          items: [
            DropdownWidgetItem(label: "Мужской", value: "true"),
            DropdownWidgetItem(label: "Женский", value: "false"),
          ],
          changedHandler: (p) => selectedSex = p,
          value: selectedSex,
        ),
      ),
      Padding(
        padding: padding,
        child: DatePickerInput(
          label: "Дата рождения",
          startDate: DateTime.utc(0),
          dateChanged: (p) {
            if (p != null) {
              birthDate = p;
            }
          },
          defaultValue: birthDate,
        ),
      ),
      Padding(
        padding: padding,
        child: DropdownWidget(
          label: "NTRP уровень",
          items: [
            DropdownWidgetItem(label: "1.0", value: "1.0"),
            DropdownWidgetItem(label: "1.5", value: "1.5"),
            DropdownWidgetItem(label: "2.0", value: "2.0"),
            DropdownWidgetItem(label: "2.5", value: "2.5"),
            DropdownWidgetItem(label: "3.0", value: "3.0"),
            DropdownWidgetItem(label: "3.5", value: "3.5"),
            DropdownWidgetItem(label: "4.0", value: "4.0"),
            DropdownWidgetItem(label: "4.5", value: "4.5"),
            DropdownWidgetItem(label: "5.0", value: "5.0"),
            DropdownWidgetItem(label: "5.5", value: "5.5"),
            DropdownWidgetItem(label: "6.0", value: "6.0"),
            DropdownWidgetItem(label: "6.5", value: "6.5"),
            DropdownWidgetItem(label: "7.0", value: "7.0"),
          ],
          changedHandler: (p) {
            if (p != null) {
              selectedNTRP = p;
            }
          },
          value: selectedNTRP,
        ),
      ),
      Padding(
        padding: padding,
        child: TextAreaInput(
          labelText: "Обо мне",
          textController: aboutMeTextController,
          maxLines: 4,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          onPressed: () => submitSecondStep(),
          child: const Text(
            "Далее",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      getBackBtn(),
      getAuthorizationBtn()
    ];
  }

  List<Widget> getFirstStepWidgets() {
    return [
      Padding(
        padding: padding,
        child: CountryAndCitySelect(
          showDistrictSelect: false,
          onCountryChanged: (p) {},
          onCityChanged: (p) {},
          controller: countryAndCitySelectController,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () => submitFirstStep(),
          child: const Text(
            "Далее",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      getAuthorizationBtn()
    ];
  }

  Widget getAuthorizationBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: TextButton(
        child: const Text("Авторизоваться"),
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/login", (r) => false);
        },
      ),
    );
  }

  Widget getBackBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          minimumSize: const Size.fromHeight(40), // NEW
        ),
        onPressed: () => {
          setState(() {
            step--;
          })
        },
        child: const Text(
          "Назад",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget getRegistrationBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size.fromHeight(40), // NEW
        ),
        onPressed: () => onPressed(context),
        child: const Text(
          "Зарегистрироваться",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 15, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              MainSettings.appName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Image.asset(
              MainSettings.imageLogoPath,
              height: 150,
              width: 150,
            ),
            ...getFormWidgets(),
          ],
        ),
      ),
    );
  }

  Future<void> onPressed(BuildContext context) async {
    if (isRegistrationInProgress) {
      return;
    }
    setState(() {
      isRegistrationInProgress = true;
    });

    try {
      var phone = phoneTextController.text
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("-", "");

      var model = PlayerRegistrationRequest(
        email: emailTextController.text,
        name: nameTextController.text,
        surname: surnameTextController.text,
        patronymic: patronymicTextController.text,
        phoneNumber: phone,
        password: passTextController.text,
        cityId: countryAndCitySelectController.city!.id,
        countryId: countryAndCitySelectController.country!.id,
        noCityOrCountryFilled: false,
        cityOrCountry: "",
        aboutMe: aboutMeTextController.text,
        ntrpRating: selectedNTRP.value,
        sex: selectedSex!.value == "true",
        birthDate: birthDate,
        noEmail: false,
        birthDateNotSet: false,
        useRegistrationLink: false,
        registrationLinkId: null,
        registrationSource: "PlayTennisApp",
      );

      if (!widget.options.showSurname) {
        model.patronymic = "Не указано";
      }

      if (!widget.options.isAboutMeRequired) {
        model.aboutMe = "Не указано";
      }

      var regResponse = widget.options.isV2
          ? await registerHandlerV2(model)
          : await registerHandler(model);

      if (!regResponse.succeeded) {
        setState(() {
          isRegistrationInProgress = false;
        });

        _errorHandler(regResponse.message!);
        return;
      }

      var authResponse = await AppServices.loginService.checkLogin();

      if (!authResponse) {
        _errorHandler("Произошла ошибка при авторизации");

        setState(() {
          isRegistrationInProgress = false;
        });
        return;
      }

      _successHandler("Регистрация и авторизация прошла успешно");

      widget.onLogin();

      setState(() {
        isRegistrationInProgress = false;
      });
    } catch (e) {
      _errorHandler(
          "Произошла ошибка при регистрации. Проверьте интернет соединение.");
      setState(() {
        isRegistrationInProgress = false;
      });
    } finally {}
  }

  Future<PlayerRegistrationResult> registerHandler(
      PlayerRegistrationRequest model) {
    return AppServices.playerRegistrationService.register(model);
  }

  Future<PlayerRegistrationResult> registerHandlerV2(
      PlayerRegistrationRequest model) {
    var advancedModel = AdvancedPlayerRegistration(
      name: model.name,
      surname: model.surname,
      phoneNumber: model.phoneNumber,
      ntrpRating: model.ntrpRating,
      password: model.password,
      sex: model.sex,
      birthDate: model.birthDate,
      cityId: model.cityId,
      countryId: model.countryId,
      cityOrCountry: model.cityOrCountry,
      noCityOrCountryFilled: model.noCityOrCountryFilled,
      registrationSource: model.registrationSource,
      aboutMe: model.aboutMe,
    );

    return AppServices.playerRegistrationService
        .registerAdvanced(advancedModel);
  }

  void _errorHandler(String error) {
    BaseApiResponseUtils.showError(context, error);
  }

  void _successHandler(String message) {
    BaseApiResponseUtils.showSuccess(context, message);
  }
}
