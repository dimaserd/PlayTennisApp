import 'dart:async';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestsList.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/SearchGameRequests.dart';
import 'package:play_tennis/main-services.dart';

class SearchGameRequestsForm extends StatefulWidget {
  final bool showMine;
  final CountryAndCitySelectController countryAndCitySelectController;
  final CurrentLoginData? loginData;

  const SearchGameRequestsForm({
    super.key,
    required this.countryAndCitySelectController,
    required this.showMine,
    required this.loginData,
  });

  @override
  State<SearchGameRequestsForm> createState() => _SearchGameRequestsFormState();
}

class _SearchGameRequestsFormState extends State<SearchGameRequestsForm> {
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
  );

  final TextEditingController queryController = TextEditingController();

  List<GameRequestSimpleModel> requests = [];
  Timer? timer;
  PublicTelegramChatForCityModel? cityModel;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) => getData());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CountryAndCitySelect(
                  showDistrictSelect: false,
                  onCityChanged: (p) {},
                  onCountryChanged: (p) {},
                  controller: widget.countryAndCitySelectController,
                ),
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(36),
                        ),
                        onPressed: () {
                          getData();
                        },
                        child: const Text("Поиск"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        cityModel != null
            ? CityChatAndChannelWidget(
                text:
                    "Мы поддерживаем отдельные теннисные островки и хотим им помочь в их техническом развитии. Глобальные чаты куда попадают все значимые новости города находятся здесь.",
                model: cityModel!,
                cityName:
                    widget.countryAndCitySelectController.city?.name ?? "Город",
              )
            : const SizedBox.shrink(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SingleChildScrollView(
              child: GameRequestsList(
                requests: requests,
                loginData: widget.loginData!,
                onChange: getData,
              ),
            ),
          ),
        )
      ],
    );
  }

  getData() {
    var playerRequest = SearchGameRequests(
      q: queryController.text,
      countryId: widget.countryAndCitySelectController.country != null
          ? widget.countryAndCitySelectController.country!.id
          : null,
      cityId: widget.countryAndCitySelectController.city != null
          ? widget.countryAndCitySelectController.city!.id
          : null,
      showMine: widget.showMine,
      count: 30,
      offSet: 0,
    );

    AppServices.gameRequestsService.search(playerRequest).then((value) {
      if (!mounted) return;
      setState(() {
        requests = value.list;
      });
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }
}
