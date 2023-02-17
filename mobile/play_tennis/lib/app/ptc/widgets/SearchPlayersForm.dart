import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import '../../../logic/ptc/models/SearchPlayersRequest.dart';
import '../../../logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import '../../../main.dart';
import '../../main/widgets/Inputs/TextInput.dart';
import 'CountryAndCitySelectWidget.dart';
import 'PlayersList.dart';

class SearchPlayersForm extends StatefulWidget {
  final PlayerLocationData locationData;
  final void Function(PlayerModel player) onTapHandler;

  const SearchPlayersForm({
    super.key,
    required this.locationData,
    required this.onTapHandler,
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
  PublicTelegramChatForCityModel? cityModel;

  int _offSet = 0;
  bool _isTapSearch = false;
  bool _isActiveLoader = true;

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
        cityModel != null
            ? CityChatAndChannelWidget(
                model: cityModel!,
                cityName: countryAndCitySelectController.city?.name ?? "Город",
              )
            : const SizedBox.shrink(),
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
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {
                    _isTapSearch = true;
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
            padding: const EdgeInsets.only(top: 8, bottom: 0),
            child: PlayersList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              players: players,
              getData: (offSet) {
                print("object $offSet");
                _offSet = offSet;
                getData();
              },
              onTapHandler: (id) {
                widget.onTapHandler(id);
              },
            ),
          ),
        ),
      ],
    );
  }

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var playerRequest = SearchPlayersRequest(
      q: queryController.text,
      sex: null,
      emailConfirmed: true,
      accountConfirmed: true,
      dataFilled: true,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );

    MyApp.playerService.search(playerRequest).then((value) {
      if (value.list.isEmpty) {
        setState(() {
          _isActiveLoader = false;
        });
      }
      // String t = queryController.text;
      // int len = value.list.length;
      // print("_isTapSearch $_isTapSearch len $len t $t offSet $_offSet");
      if (_offSet == 0 || _isTapSearch == true) {
        _isTapSearch = false;
        setState(() {
          players = value.list;
        });
      } else {
        setState(() {
          players += value.list;
        });
      }
    });
    if (cityId != null) {
      MyApp.cityService.getById(cityId, (p0) {}).then((value) {
        setState(() {
          cityModel = value;
        });
      });
    } else {
      setState(() {
        cityModel = null;
      });
    }
  }
}
