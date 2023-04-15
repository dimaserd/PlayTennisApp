import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameRequestsList.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/SearchGameRequests.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) => getData());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountryAndCitySelect(
          onCityChanged: (p) {},
          onCountryChanged: (p) {},
          controller: widget.countryAndCitySelectController,
        ),
        Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 5),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(36), // NEW
                  ),
                  onPressed: () {
                    getData();
                  },
                  child: const Text("Поиск"),
                ),
              ),
            ],
          ),
        ),
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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
