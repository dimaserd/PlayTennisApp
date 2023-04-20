import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentsList.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-services.dart';
import 'dart:async';

class SearchTournamentsForm extends StatefulWidget {
  final LocationData locationData;
  final void Function(TournamentSimpleModel trainer) onTapHandler;

  const SearchTournamentsForm({
    super.key,
    required this.locationData,
    required this.onTapHandler,
  });

  @override
  State<SearchTournamentsForm> createState() => _SearchTournamentsForm();
}

class _SearchTournamentsForm extends State<SearchTournamentsForm> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<TournamentSimpleModel> tournaments = [];
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
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                CountryAndCitySelect(
                  showDistrictSelect: false,
                  onCityChanged: (p) {
                    onCountryChanged();
                  },
                  onCountryChanged: (p) {
                    onCountryChanged();
                  },
                  controller: countryAndCitySelectController,
                ),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Поисковая строка',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
        cityModel != null
            ? CityChatAndChannelWidget(
                text:
                    "Все результаты и новости турнира попадают в специальный чат связанный с городом.",
                model: cityModel!,
                cityName: countryAndCitySelectController.city?.name ?? "Город",
              )
            : const SizedBox.shrink(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0),
            child: TournamentsList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              tournaments: tournaments,
              getData: (offSet) {
                _offSet = offSet;
                getData();
              },
              onTapHandler: (id) {
                // widget.onTapHandler(id);
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

  void onCountryChanged() {
    _offSet = 0;
    getData();
  }

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var trainerRequest = GetTournamentsRequest(
      openForParticipantsJoining: null,
      activityStatus: null,
      durationType: null,
      showMine: null,
      useHiddenFilter: false,
      hidden: null,
      isExternal: null,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );

    AppServices.tournamentService.search(trainerRequest).then((value) {
      if (!mounted) {
        return;
      }
      if (value.list.isEmpty) {
        setState(() {
          _isActiveLoader = false;
        });
      }

      if (_offSet == 0 || _isTapSearch == true) {
        _isTapSearch = false;
        setState(() {
          tournaments = value.list;
        });
      } else {
        setState(() {
          tournaments += value.list;
        });
      }
    });
    if (cityId != null) {
      AppServices.cityService
          .getTelegramDataById(cityId, (p0) {})
          .then((value) {
        if (!mounted) {
          return;
        }
        setState(() {
          cityModel = value;
        });
      });
    } else {
      if (!mounted) {
        return;
      }
      setState(() {
        cityModel = null;
      });
    }
  }
}
