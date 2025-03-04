import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/CustomDateAndTimePickerWidget.dart';
import 'package:play_tennis/app/ptc/widgets/courts/CourtTypeSelect.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CountrySimpleModel.dart';

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
  final String label;
  final CustomDateAndTimePickerWidgetController dateAndTimePickerController;
  final TextEditingController courtNameController;
  final CourtTypeSelectController courtTypeSelectController;
  final CountryAndCitySelectController countryAndCitySelectController;

  final Function(String error) errorHandler;
  final Function(GameFormCourtData data) successHandler;
  final VoidCallback scroll;

  const GameFormCourtDataWidget({
    super.key,
    required this.label,
    required this.scroll,
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
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
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
      TextField(
          decoration: const InputDecoration(
            labelText: "Корт",
          ),
          controller: courtNameController,
          autofocus: false,
          onTap: () {
            scroll();
          }),
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
        child: const Text(
          "Далее",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
