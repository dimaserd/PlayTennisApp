import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import '../../../logic/ptc/models/CityModel.dart';
import '../../../logic/ptc/models/CountrySimpleModel.dart';
import '../../../logic/ptc/models/SearchCities.dart';
import '../../../logic/ptc/models/SearchCountries.dart';
import '../../../main.dart';

class CountryAndCitySelectController {
  CountrySimpleModel? country;
  CityModel? city;

  setCountry(CountryNameModel nameModel) {
    country = CountrySimpleModel(
      name: nameModel.name,
      id: nameModel.id,
      citiesCount: 0,
    );
  }

  setLocationData(PlayerLocationData locationData) {
    city = locationData.city;

    if (locationData.country != null) {
      setCountry(locationData.country!);
    }
  }
}

class CountryAndCitySelect extends StatefulWidget {
  final Function(CountrySimpleModel)? onCountryChanged;
  final Function(CityModel)? onCityChanged;
  final CountryAndCitySelectController controller;

  const CountryAndCitySelect({
    super.key,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.controller,
  });

  @override
  State<CountryAndCitySelect> createState() => _CountryAndCitySelectState();
}

class _CountryAndCitySelectState extends State<CountryAndCitySelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<CountrySimpleModel>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (CountrySimpleModel s) => false,
            showSearchBox: false, //Для страны ничего не ищем
            isFilterOnline: true,
          ),
          compareFn: (item1, item2) => item1.id == item2.id,
          filterFn: (country, filter) => country.name!.contains(filter),
          asyncItems: (String filter) => getCountriesData(filter),
          itemAsString: (CountrySimpleModel u) => u.name!,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Выбор страны",
              hintText: "Выберите страну",
            ),
          ),
          onChanged: (country) {
            widget.controller.country = country;

            if (widget.onCountryChanged != null) {
              widget.onCountryChanged!(widget.controller.country!);
            }
          },
          selectedItem: widget.controller.country,
        ),
        DropdownSearch<CityModel>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (CityModel s) => false,
            showSearchBox: true,
            isFilterOnline: true,
          ),
          compareFn: (item1, item2) => item1.id == item2.id,
          filterFn: (country, filter) => country.name!.contains(filter),
          asyncItems: (String filter) => getCitiesData(filter),
          itemAsString: (CityModel u) => u.name!,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Выбор города",
              hintText: "Выберите город",
            ),
          ),
          onChanged: (city) {
            widget.controller.city = city;

            if (widget.onCityChanged != null) {
              widget.onCityChanged!(widget.controller.city!);
            }
          },
          selectedItem: widget.controller.city,
        ),
      ],
    );
  }

  Future<List<CountrySimpleModel>> getCountriesData(String filter) {
    var model = SearchCountries(
      q: filter,
      count: 20,
      offSet: 0,
    );

    return MyApp.countryService.searchCountries(model).then((value) {
      return value.list;
    });
  }

  Future<List<CityModel>> getCitiesData(String filter) {
    if (widget.controller.country == null) {
      return Future.value(List<CityModel>.empty());
    }

    var model = SearchCities(
      q: filter,
      countryId: widget.controller.country!.id,
      count: 20,
      offSet: 0,
    );

    return MyApp.countryService.searchCities(model).then((value) {
      return value.list;
    });
  }
}
