import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:play_tennis/app/ptc/widgets/courts/SearchCourtsForm.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/SearchTrainersForm.dart';
import '../CountryAndCitySelectWidget.dart';
import '../communities/SearchCommunityForm.dart';
import '../../../../logic/ptc/models/PlayerLocationData.dart';
import '../game-requests/SearchGameRequestsForm.dart';

class PlayTabbedPage extends StatefulWidget {
  final PlayerLocationData locationData;
  final Function(int index) onItemTapped;
  final int selectedIndex;

  PlayTabbedPage({
    Key? key,
    required this.locationData,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  State<PlayTabbedPage> createState() => _PlayTabbedPageState(
      locationData: locationData,
      onItemTapped: onItemTapped,
      selectedIndex: selectedIndex);
}

class _PlayTabbedPageState extends State<PlayTabbedPage> {
  _PlayTabbedPageState(
      {required this.locationData,
      required this.onItemTapped,
      required this.selectedIndex});

  PlayerLocationData locationData;
  Function(int index) onItemTapped;
  late List<Widget> widgetOptions;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    widgetOptions = <Widget>[
      SearchGameRequestsForm(
        countryAndCitySelectController: CountryAndCitySelectController(),
        showMine: false,
      ),
      SearchCommunityForm(
        locationData: locationData,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchTrainersForm(
        locationData: locationData,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchCourtsForm(
        locationData: locationData,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          iconSize: 20,
          backgroundColor: Colors.transparent,
          showElevation: false,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          containerHeight: 50,
          selectedIndex: selectedIndex,
          onItemSelected: (value) {
            onItemTapped(value);
          },
          items: [
            BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text(
                  'Игроки',
                  style: TextStyle(fontSize: 13),
                ),
                activeColor: Colors.black,
                textAlign: TextAlign.center),
            BottomNavyBarItem(
                icon: const Icon(Icons.people),
                title: const Text(
                  'Сообщества',
                  style: TextStyle(fontSize: 13),
                ),
                textAlign: TextAlign.center,
                activeColor: const Color.fromARGB(255, 212, 35, 76)),
            BottomNavyBarItem(
                icon: const Icon(Icons.contacts),
                title: const Text(
                  ' Тренеры',
                  style: TextStyle(fontSize: 13),
                ),
                textAlign: TextAlign.center,
                activeColor: Colors.blue),
            BottomNavyBarItem(
                icon: const Icon(Icons.sports_tennis),
                title: const Text(
                  ' Корты',
                  style: TextStyle(fontSize: 13),
                ),
                textAlign: TextAlign.center,
                activeColor: Colors.blue)
          ]),
      resizeToAvoidBottomInset: false,
    );
  }
}
