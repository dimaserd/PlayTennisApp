import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/notifications/NotificationsList.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/services/NotificationService.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-services.dart';
import 'dart:async';

class SearchNotificationsForm extends StatefulWidget {
  final LocationData locationData;

  const SearchNotificationsForm({
    super.key,
    required this.locationData,
  });

  @override
  State<SearchNotificationsForm> createState() =>
      _SearchNotificationsFormState();
}

class _SearchNotificationsFormState extends State<SearchNotificationsForm> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<NotificationModel> notifications = [];

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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0),
            child: NotificationsList(
              isActiveLoader: _isActiveLoader,
              offset: _offSet,
              notifications: notifications,
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
    var searchModel = ClientNotificationsSearchQueryModel(
      createdOn: null,
      read: null,
      count: 10,
      offSet: _offSet,
    );

    AppServices.notificationService.search(searchModel, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при запросе списка уведомлений.");
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
          notifications = value.list;
        });
      } else {
        setState(() {
          notifications += value.list;
        });
      }
    });
  }
}
