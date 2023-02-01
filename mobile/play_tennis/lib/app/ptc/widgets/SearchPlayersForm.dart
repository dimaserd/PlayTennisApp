import 'package:flutter/material.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import '../../../logic/ptc/models/SearchPlayersRequest.dart';
import '../../../main.dart';
import '../../main/widgets/Inputs/TextInput.dart';
import 'CountryAndCitySelectWidget.dart';
import 'PlayersList.dart';

class SearchPlayersForm extends StatefulWidget {
  final PlayerLocationData locationData;
  final double playersListWidgetHeight;
  final void Function(PlayerModel player) onTapHandler;

  const SearchPlayersForm({
    super.key,
    required this.locationData,
    required this.onTapHandler,
    required this.playersListWidgetHeight,
  });

  @override
  State<SearchPlayersForm> createState() => _SearchPlayersFormState();
}

class _SearchPlayersFormState extends State<SearchPlayersForm> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  final TextEditingController queryController = TextEditingController();

  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  List<PlayerModel> players = [];

  @override
  void initState() {
    if (!mounted) {
      return;
    }
    countryAndCitySelectController.setLocationData(widget.locationData);
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountryAndCitySelect(
          onCityChanged: (p) {
            getData();
          },
          onCountryChanged: (p) {
            getData();
          },
          controller: countryAndCitySelectController,
        ),
        TextInput(
          labelText: "Поисковая строка",
          textController: queryController,
        ),
        Container(
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
                    minimumSize: const Size.fromHeight(40), // NEW
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PlayersList(
            players: players,
            height: widget.playersListWidgetHeight,
            onTapHandler: (id) {
              widget.onTapHandler(id);
            },
          ),
        ),
      ],
    );
  }

  getData() {
    print("getData() called");
    var playerRequest = SearchPlayersRequest(
      q: queryController.text,
      sex: null,
      emailConfirmed: true,
      accountConfirmed: true,
      dataFilled: true,
      cityId: countryAndCitySelectController.city != null
          ? countryAndCitySelectController.city!.id
          : null,
      count: 30,
      offSet: 0,
    );

    MyApp.playerService.search(playerRequest).then((value) {
      setState(() {
        players = value.list;
      });
    });
  }
}
