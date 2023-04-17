import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/TrainerCard.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import 'package:play_tennis/main-services.dart';
import 'dart:async';
import 'TrainerList.dart';

class SearchTrainersForm extends StatefulWidget {
  final PlayerLocationData locationData;
  final void Function(TrainerCard trainer) onTapHandler;

  const SearchTrainersForm({
    super.key,
    required this.locationData,
    required this.onTapHandler,
  });

  @override
  State<SearchTrainersForm> createState() => _SearchTrainersForm();
}

class _SearchTrainersForm extends State<SearchTrainersForm> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<TrainerCardSimpleModel> trainers = [];
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: CountryAndCitySelect(
                  showDistrictSelect: false,
                  onCityChanged: (p) {
                    onCountryChanged();
                  },
                  onCountryChanged: (p) {
                    onCountryChanged();
                  },
                  controller: countryAndCitySelectController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Поисковая строка',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0),
            child: TrainerList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              trainers: trainers,
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

    var trainerRequest = SearchTrainerCardsRequest(
      q: _searchController.text,
      cityId: cityId,
      count: 10,
      offSet: _offSet,
    );

    AppServices.trainerCardService
        .search(trainerRequest, _errorHandler)
        .then((value) {
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
          trainers = value.list;
        });
      } else {
        setState(() {
          trainers += value.list;
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

  _errorHandler(String error) {
    BaseApiResponseUtils.showError(context, error);
  }
}
