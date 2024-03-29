import 'dart:async';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/cities/CityChatAndChannelWidget.dart';
import 'package:play_tennis/app/ptc/widgets/communities/CommunityList.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/cities/PublicTelegramChatForCityModel.dart';
import 'package:play_tennis/logic/ptc/services/CommunityCardService.dart';
import 'package:play_tennis/main-services.dart';

class SearchCommunityForm extends StatefulWidget {
  final LocationData locationData;
  final void Function(SearchCommunityCards player) onTapHandler;

  const SearchCommunityForm({
    super.key,
    required this.locationData,
    required this.onTapHandler,
  });

  @override
  State<SearchCommunityForm> createState() => _SearchCommunityForm();
}

class _SearchCommunityForm extends State<SearchCommunityForm> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<CommunityCardSimpleModel> community = [];
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                    "Мы поддерживаем отдельные теннисные островки и хотим им помочь в их техническом развитии. Глобальные чаты куда попадают все значимые новости города находятся здесь.",
                model: cityModel!,
                cityName: countryAndCitySelectController.city?.name ?? "Город",
              )
            : const SizedBox.shrink(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0),
            child: CommunityList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              community: community,
              getData: (offSet) {
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

  void onCountryChanged() {
    _offSet = 0;
    getData();
  }

  getData() {
    var cityId = countryAndCitySelectController.city?.id;

    var communityRequest = SearchCommunityCards(
        q: _searchController.text, cityId: cityId, count: 10, offSet: _offSet);

    AppServices.communityService
        .search(communityRequest, _errorHandler)
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
          community = value.list;
        });
      } else {
        setState(() {
          community += value.list;
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
