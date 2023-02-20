import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/TrainerList.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import '../../../logic/ptc/models/SearchPlayersRequest.dart';
import '../../../logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import '../../../main-services.dart';
import 'CountryAndCitySelectWidget.dart';
import 'PlayersList.dart';
import 'dart:async';

class SearchTrainersForm extends StatefulWidget {
  final PlayerLocationData locationData;
  final void Function(PlayerModel player) onTapHandler;

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
            child: TrainerList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              trainers: trainers,
              getData: (offSet) {
                print("object $offSet");
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

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var trainerRequest = SearchTrainerCardsRequest(
        q: _searchController.text, cityId: cityId, count: 10, offSet: _offSet);

    AppServices.trainerCardService.search(trainerRequest).then((value) {
      if (mounted) {
      var list = value.list;
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
      }
    });
    if (cityId != null) {
      AppServices.cityService.getById(cityId, (p0) {}).then((value) {
        if (mounted) {
        setState(() {
          cityModel = value;
        });
        }
      });
    } else {
      if (mounted) {
      setState(() {
        cityModel = null;
      });
      }
    }
  }
}
