import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/TextInput.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/CreateGameRequest.dart';
import '../../../../baseApiResponseUtils.dart';
import '../../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../../main-services.dart';
import '../../../../main.dart';
import '../CountryAndCitySelectWidget.dart';
import '../CustomDateAndTimePickerWidget.dart';

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

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getLocationData().then((value) {
      if (!mounted) return;
      if (value == null) return;

      setState(() {
        locationData = value;
        countryAndCitySelectController.setLocationData(locationData!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locationData == null) {
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: getStepWidgets(),
        ),
      ),
    );
  }

  List<Widget> getStepWidgets() {
    return [
      CountryAndCitySelect(
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
          minimumSize: const Size.fromHeight(35), // NEW
        ),
        onPressed: _clickHandler,
        child: const Text("Создать"),
      )
    ];
  }

  Future _clickHandler() async {
    if (MyApp.inProccess) {
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
        Navigator.of(context).pop();
      }
      MyApp.inProccess = false;
    });
  }
}
