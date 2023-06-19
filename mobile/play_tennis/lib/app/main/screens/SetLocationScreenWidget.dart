import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/main-routes.dart';
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
              child: Column(
                children: [
                  CountryAndCitySelect(
                    showDistrictSelect: false,
                    onCountryChanged: (p) {},
                    onCityChanged: (p) {},
                    controller: countryAndCitySelectController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: () {
                      _clickHandler(context);
                    },
                    child: const Text("Далее"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                child: const Text("Зарегистрироваться"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.registration,
                    (r) => true,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                child: const Text("Авторизоваться"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.login,
                    (r) => true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clickHandler(BuildContext context) {
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

    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  }
}
