import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/main-state.dart';

class SetLocationScreenWidget extends StatelessWidget {
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  SetLocationScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              "Добро пожаловать на ${MainSettings.appName}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Center(
              child: Image.asset(
                MainSettings.loadingPath,
                height: 150,
                width: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
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
                onPressed: () {
                  if (countryAndCitySelectController.country == null ||
                      countryAndCitySelectController.city == null) {
                    BaseApiResponseUtils.showError(
                        context, "Необходимо указать страну и город");
                    return;
                  }
                  var country = countryAndCitySelectController.country!;

                  var locationData = LocationData(
                    country: CountryNameModel(
                      name: country.name,
                      id: country.id,
                    ),
                    city: countryAndCitySelectController.city,
                  );

                  MainState.locationData = locationData;

                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (r) => false);
                },
                child: const Text("Далее"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
