import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/SearchGameRequestsForm.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/main-services.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  LocationData? locationData;
  CurrentLoginData? loginData;
  CountryAndCitySelectController citySelectController =
      CountryAndCitySelectController();

  bool showFloat = false;

  void loadLocationData() {
    AppServices.playerService.getLocationData((e) => {}).then((value) {
      setState(() {
        citySelectController.setLocationData(value);
        locationData = value;
      });
    });
  }

  void loadLoginData() {
    AppServices.loginService.getLoginData().then((value) {
      if (!value.isAuthenticated) {
        BaseApiResponseUtils.showInfo(context,
            "Вы не можете пользоваться функционалом заявок на игру в полном объеме. Для этого вам необходимо зарегистрироваться/авторизоваться. Перейдите в меню и нажмите 'Логин'.");
      }
      setState(() {
        loginData = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocationData();
    loadLoginData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  if (loginData == null || !loginData!.isAuthenticated) {
                    BaseApiResponseUtils.showInfo(context,
                        "Вы не можете создавать заявки на игру. Для этого вам необходимо зарегистрироваться/авторизоваться. Перейдите в меню и нажмите 'Логин'.");
                    return;
                  }
                  Navigator.of(context).pushNamed("/game-requests/add");
                },
                icon: const Icon(Icons.add_circle),
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Заявки на игру",
                ),
                Tab(
                  text: "Мои заявки",
                ),
              ],
            ),
            title: const Text('Играть'),
          ),
          drawer: const SideDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.white,
              child: TabBarView(
                children: getWidgets(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (locationData == null || loginData == null) {
      return [
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
      ];
    }

    return [
      SearchGameRequestsForm(
        countryAndCitySelectController: citySelectController,
        loginData: loginData,
        showMine: false,
      ),
      SearchGameRequestsForm(
        countryAndCitySelectController: citySelectController,
        loginData: loginData,
        showMine: true,
      ),
    ];
  }
}
