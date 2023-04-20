import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/TextInput.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/CustomDateAndTimePickerWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/PlayerConfirmationWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/TelegramLinkTipWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/CreateGameRequest.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class AddGameRequestForm extends StatefulWidget {
  const AddGameRequestForm({super.key});

  @override
  State<AddGameRequestForm> createState() => _AddGameRequestFormState();
}

class _AddGameRequestFormState extends State<AddGameRequestForm> {
  TextEditingController textEditingController = TextEditingController(text: "");
  CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  CustomDateAndTimePickerWidgetController dateAndTimeWidgetController =
      CustomDateAndTimePickerWidgetController(
    value: CustomDateAndTimePickerWidgetData.now(),
  );

  DateTime selectedDate = DateTime.now();

  PlayerLocationData? locationData;
  PlayerData? playerData;

  @override
  void initState() {
    super.initState();
    getLocationData();
    getPlayerData();
  }

  void getLocationData() {
    AppServices.playerService.getPlayerLocationData((e) => {}).then((value) {
      if (!mounted || value == null) {
        return;
      }

      setState(() {
        locationData = value;
        countryAndCitySelectController.setPlayerLocationData(locationData!);
      });
    });
  }

  void getPlayerData() {
    AppServices.playerService.getData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      if (mounted) {
        setState(() {
          playerData = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locationData == null || playerData == null) {
      return SizedBox(
        child: Column(
          children: const [
            Loading(text: "Загрузка"),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              ...getConfirmationWidgets(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: getStepWidgets(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getConfirmationWidgets() {
    if (playerData == null) {
      return [];
    }

    return [
      playerData!.telegramUserId == null
          ? TelegramLinkTipWidget(
              player: playerData!,
              updateTelegram: (id) {
                setState(() {
                  playerData!.telegramUserId = id;
                });
              },
            )
          : const SizedBox.shrink(),
      !playerData!.accountConfirmed
          ? PlayerConfirmationWidget(
              player: playerData!,
            )
          : const SizedBox.shrink(),
      const SizedBox(
        height: 5,
      ),
    ];
  }

  List<Widget> getStepWidgets() {
    return [
      Column(
        children: [
          CountryAndCitySelect(
            showDistrictSelect: false,
            onCityChanged: (p) {},
            onCountryChanged: (p) {},
            controller: countryAndCitySelectController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomDateAndTimePickerWidget(
            dataChanged: (p) => {},
            dateLabel: "Выбрать дату игры",
            timeLabel: "Время игры",
            dateDropDownLabel: "Дата игры",
            controller: dateAndTimeWidgetController,
          ),
          TextAreaInput(
            labelText: "Текст заявки",
            textController: textEditingController,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(40),
            ),
            onPressed: _clickHandler,
            child: const Text(
              "Создать",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    ];
  }

  Future _clickHandler() async {
    if (MyApp.inProccess) {
      return;
    }

    if (playerData == null) {
      return;
    }

    if (!playerData!.accountConfirmed) {
      BaseApiResponseUtils.showError(
        context,
        "Чтобы создавать заявки на игру вам необходимо подтвердить вашу учётную запись.",
      );
      return;
    }

    var dateTimeData = dateAndTimeWidgetController.value;

    if (dateTimeData.selectedTime == null) {
      BaseApiResponseUtils.showError(
          context, "Вы не указали время начала игры");
      return;
    }

    if (countryAndCitySelectController.city == null ||
        countryAndCitySelectController.country == null) {
      BaseApiResponseUtils.showError(context, "Вы не указали местоположение");
      return;
    }

    MyApp.inProccess = true;

    var model = CreateGameRequest(
      countryId: countryAndCitySelectController.country!.id,
      cityId: countryAndCitySelectController.city!.id,
      // по-умолчанию ставится московский часовой пояс
      matchDateUtc: dateTimeData.dateTime.subtract(
        const Duration(hours: 3),
      ),
      description: textEditingController.text,
    );

    AppServices.gameRequestsService.create(model).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);
      if (value.isSucceeded) {
        MyApp.inProccess = false;
        Navigator.of(context).pop();
      }
      MyApp.inProccess = false;
    });
  }
}
