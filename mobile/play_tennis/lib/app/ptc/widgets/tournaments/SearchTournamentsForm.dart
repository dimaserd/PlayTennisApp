import 'package:flutter/material.dart';
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
  List<TournamentSimpleModel> openedForParticipationTournaments = [];
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
                      (states) => const Color.fromARGB(255, 51, 187, 255)),
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
            finishedTournaments.isEmpty &&
            openedForParticipationTournaments.isEmpty) ...{
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
              tournaments: activeTournaments,
              text: "Текущие турниры:",
            )
          },
          if (openedForParticipationTournaments.isNotEmpty) ...{
            StickyHeaderList(
              tournaments: openedForParticipationTournaments,
              text: "Открытые для записи:",
            )
          },
          if (finishedTournaments.isNotEmpty) ...{
            StickyHeaderList(
              tournaments: finishedTournaments,
              text: "Завершенные",
            )
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

  GetTournamentsRequest getBaseRequest() {
    var cityId = countryAndCitySelectController.city?.id;

    return GetTournamentsRequest(
      openForParticipantsJoining: null,
      activityStatus: TournamentActivityStatus.Active,
      showMine: null,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );
  }

  getActiveTournaments() {
    var activeRequest = getBaseRequest();
    activeRequest.activityStatus = TournamentActivityStatus.Active;

    AppServices.tournamentService.search(activeRequest, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при поиске турниров.");
    }).then((value) {
      if (!mounted) {
        return;
      }

      print("Active ${value.list.length}");

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
  }

  getFinishedTournaments() {
    var finishedRequest = getBaseRequest();
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
  }

  getPlannedTournaments() {
    var plannedRequest = getBaseRequest();
    plannedRequest.activityStatus = TournamentActivityStatus.Planned;

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
  }

  getOpenedForParticipationTournaments() {
    var plannedRequest = getBaseRequest();
    plannedRequest.activityStatus = TournamentActivityStatus.Planned;
    plannedRequest.openForParticipantsJoining = true;

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
          openedForParticipationTournaments = value.list;
        });
      } else {
        setState(() {
          openedForParticipationTournaments += value.list;
        });
      }
    });
  }

  getData() {
    getActiveTournaments();
    getOpenedForParticipationTournaments();
    getFinishedTournaments();
    getPlannedTournaments();
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
