import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CountrySimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/SearchCities.dart';
import 'package:play_tennis/logic/ptc/models/cities/SearchCountries.dart';
import 'package:play_tennis/logic/ptc/services/CityService.dart';
import 'package:play_tennis/main-services.dart';

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

  setPlayerLocationData(PlayerLocationData locationData) {
    city = locationData.city;

    if (locationData.country != null) {
      setCountry(locationData.country!);
    }
  }

  setLocationData(LocationData locationData) {
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
  final bool showDistrictSelect;

  const CountryAndCitySelect({
    super.key,
    required this.onCountryChanged,
    required this.onCityChanged,
    required this.controller,
    required this.showDistrictSelect,
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
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                hintText: "Поиск города",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
              ),
            ),
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
        widget.showDistrictSelect
            ? DropdownSearch<CityDistrictModel>.multiSelection(
                popupProps: PopupPropsMultiSelection.menu(
                  showSelectedItems: true,
                  disabledItemFn: (CityDistrictModel s) => false,
                  showSearchBox: true,
                  isFilterOnline: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      hintText: "Поиск района",
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                ),
                compareFn: (item1, item2) => item1.id == item2.id,
                filterFn: (country, filter) => country.name!.contains(filter),
                asyncItems: (String filter) => getAreasData(),
                itemAsString: (CityDistrictModel u) => u.name!,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Выбор района",
                    hintText: "Выберите район",
                  ),
                ),
                onChanged: (areas) {},
                selectedItems: List.empty(),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Future<List<CountrySimpleModel>> getCountriesData(String filter) {
    var model = SearchCountries(
      q: filter,
      count: 20,
      offSet: 0,
    );

    return AppServices.countryService.searchCountries(model).then((value) {
      return value.list;
    });
  }

  Future<List<CityDistrictModel>> getAreasData() async {
    var id = widget.controller.city?.id ?? "";
    return await AppServices.cityService
        .getCityDistricts(id, (error) {})
        .then((value) {
      return value;
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

    return AppServices.countryService
        .searchCities(model, _errorHandler)
        .then((value) {
      return value.list;
    });
  }

  _errorHandler(String error) {
    BaseApiResponseUtils.showError(context, error);
  }
}
