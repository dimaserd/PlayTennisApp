import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/services/CityService.dart';
import 'package:play_tennis/main-services.dart';

class SelectCityDistrictsWidget extends StatefulWidget {
  final String cityId;
  const SelectCityDistrictsWidget({required this.cityId, super.key});

  @override
  State<SelectCityDistrictsWidget> createState() =>
      _SelectCityDistrictsWidgetState();
}

class _SelectCityDistrictsWidgetState extends State<SelectCityDistrictsWidget> {
  List<CityDistrictModel> districts = [];

  @override
  void initState() {
    getDistricts();
    super.initState();
  }

  getDistricts() async {
    var value = await AppServices.cityService
        .getCityDistricts(widget.cityId, (p0) => {});
    setState(() {
      districts = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
