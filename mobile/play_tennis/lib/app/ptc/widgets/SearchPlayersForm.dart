import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import '../../../logic/ptc/models/SearchPlayersRequest.dart';
import '../../../logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import '../../../main-services.dart';
import 'CountryAndCitySelectWidget.dart';
import 'PlayersList.dart';
import 'dart:async';

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
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountryAndCitySelect(
          onCityChanged: (p) {
            _offSet = 0;
            getData();
          },
          onCountryChanged: (p) {
            _offSet = 0;
            getData();
          },
          controller: countryAndCitySelectController,
        ),
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Поисковая строка',
            suffixIcon: Icon(Icons.search),
          ),
        ),
        cityModel != null
            ? CityChatAndChannelWidget(
                model: cityModel!,
                cityName: countryAndCitySelectController.city?.name ?? "Город",
              )
            : const SizedBox.shrink(),
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Здесь вы можете добавить логику поиска
      getData();
    });
  }

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var playerRequest = SearchPlayersRequest(
      q: _searchController.text,
      sex: null,
      emailConfirmed: true,
      accountConfirmed: true,
      dataFilled: true,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );

    AppServices.playerService.search(playerRequest).then((value) {
      if (value.list.isEmpty) {
        setState(() {
          _isActiveLoader = false;
        });
      }

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
      AppServices.cityService.getById(cityId, (p0) {}).then((value) {
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
