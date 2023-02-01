import 'package:flutter/material.dart';
import '../../../../logic/ptc/models/CityModel.dart';
import '../../../../logic/ptc/models/CountrySimpleModel.dart';
import '../../../main/widgets/Inputs/TextInput.dart';
import '../CountryAndCitySelectWidget.dart';
import '../CourtTypeSelect.dart';
import '../CustomDateAndTimePickerWidget.dart';

class GameFormCourtData {
  String courtName;
  String courtType;
  CustomDateAndTimePickerWidgetData gameDateTimeData;
  CityModel selectedCity;
  CountrySimpleModel selectedCountry;

  GameFormCourtData({
    required this.courtName,
    required this.courtType,
    required this.gameDateTimeData,
    required this.selectedCity,
    required this.selectedCountry,
  });
}

class GameFormCourtDataWidget extends StatelessWidget {
  final CustomDateAndTimePickerWidgetController dateAndTimePickerController;
  final TextEditingController courtNameController;
  final CourtTypeSelectController courtTypeSelectController;
  final CountryAndCitySelectController countryAndCitySelectController;

  final Function(String error) errorHandler;
  final Function(GameFormCourtData data) successHandler;

  const GameFormCourtDataWidget({
    super.key,
    required this.errorHandler,
    required this.successHandler,
    required this.dateAndTimePickerController,
    required this.courtNameController,
    required this.courtTypeSelectController,
    required this.countryAndCitySelectController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: getWidgets(),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "3. Укажите время и место игры",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      CountryAndCitySelect(
        onCityChanged: (p) {},
        onCountryChanged: (p) {},
        controller: countryAndCitySelectController,
      ),
      const SizedBox(
        height: 10,
      ),
      CustomDateAndTimePickerWidget(
        dataChanged: (p) {},
        controller: dateAndTimePickerController,
        dateLabel: "Выбрать дату игры",
        timeLabel: "Время игры",
        dateDropDownLabel: "Дата игры",
        dateItemsParam: CustomDateAndTimePickerWidgetConsts.dateItemsNoTommorow,
      ),
      const SizedBox(
        height: 10,
      ),
      TextInput(
        labelText: "Корт",
        textController: courtNameController,
      ),
      const SizedBox(
        height: 10,
      ),
      CourtTypeSelect(
        controller: courtTypeSelectController,
      ),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size.fromHeight(45),
        ),
        onPressed: _clickHandler,
        child: const Text("Далее"),
      )
    ];
  }

  void _clickHandler() async {
    var dateTimeData = dateAndTimePickerController.value;

    if (dateTimeData.selectedTime == null) {
      errorHandler("Вы не указали время начала игры");
      return;
    }

    if (dateTimeData.selectedTime == null) {
      errorHandler("Вы не указали время начала игры");
      return;
    }

    if (countryAndCitySelectController.city == null ||
        countryAndCitySelectController.country == null) {
      errorHandler("Вы не указали местоположение");
      return;
    }

    if (courtNameController.text == "") {
      errorHandler("Вы не указали корт, на котором играли");
      return;
    }

    var data = GameFormCourtData(
      courtName: courtNameController.text,
      courtType: courtTypeSelectController.value,
      gameDateTimeData: dateTimeData,
      selectedCity: countryAndCitySelectController.city!,
      selectedCountry: countryAndCitySelectController.country!,
    );

    successHandler(data);
  }
}
