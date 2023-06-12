import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/StickyHeaderList.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
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

  List<TournamentSimpleModel> activeTournaments = [];
  List<TournamentSimpleModel> plannedTournaments = [];
  List<TournamentSimpleModel> finishedTournaments = [];
  PublicTelegramChatForCityModel? cityModel;

  int _offSet = 0;
  bool _isTapSearch = false;
  bool _isActiveLoader = true;
  bool _isShowMine = false;

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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Card(
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
                      onCountryOrCityChanged();
                    },
                    onCountryChanged: (p) {
                      onCountryOrCityChanged();
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
        ),
        SliverToBoxAdapter(
          child: Card(
            child: Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => Color.fromARGB(255, 51, 187, 255)),
                  checkColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  value: _isShowMine,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isShowMine = newValue!;
                    });
                  },
                ),
                const Text("Мои турниры")
              ],
            ),
          ),
        ),
        if (activeTournaments.isEmpty &&
            plannedTournaments.isEmpty &&
            finishedTournaments.isEmpty) ...{
          const SliverToBoxAdapter(
          child: Center(
            child: Text(
              "По вашему запросу турниры не найдены",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )),
        } else ...{
          if (activeTournaments.isNotEmpty) ...{
            StickyHeaderList(
                tournaments: activeTournaments, text: "Текущие турниры:")
          },
          if (plannedTournaments.isNotEmpty) ...{
            StickyHeaderList(
                tournaments: plannedTournaments,
                text: "Открытые для записи турниры:")
          },
          if (finishedTournaments.isNotEmpty) ...{
            StickyHeaderList(
                tournaments: finishedTournaments, text: "Завершенные")
          }
        }
      ],
      reverse: false,
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Здесь вы можете добавить логику поиска
      getData();
    });
  }

  void onCountryOrCityChanged() {
    _offSet = 0;
    getData();
  }

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var activeRequest = GetTournamentsRequest(
      openForParticipantsJoining: null,
      activityStatus: TournamentActivityStatus.Active,
      durationType: null,
      showMine: _isShowMine,
      useHiddenFilter: false,
      hidden: false,
      isExternal: false,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );

    AppServices.tournamentService.search(activeRequest, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при поиске турниров.");
    }).then((value) {
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
          activeTournaments = value.list;
        });
      } else {
        setState(() {
          activeTournaments += value.list;
        });
      }
    });

    var finishedRequest = activeRequest;
    finishedRequest.activityStatus = TournamentActivityStatus.Finished;

    AppServices.tournamentService.search(finishedRequest, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при поиске турниров.");
    }).then((value) {
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
          finishedTournaments = value.list;
        });
      } else {
        setState(() {
          finishedTournaments += value.list;
        });
      }
    });

    var plannedRequest = activeRequest;
    finishedRequest.activityStatus = TournamentActivityStatus.Planned;

    AppServices.tournamentService.search(plannedRequest, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при поиске турниров.");
    }).then((value) {
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
          plannedTournaments = value.list;
        });
      } else {
        setState(() {
          plannedTournaments += value.list;
        });
      }
    });

    getCityData();
  }

  getCityData() {
    var cityId = countryAndCitySelectController.city?.id;

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
