import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:play_tennis/app/ptc/widgets/SearchCourtsForm.dart';
import 'SearchPlayersForm.dart';
import 'SearchCommunityForm.dart';
import 'SearchTrainersForm.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../main/widgets/Loading.dart';

class MyTabbedPage extends StatefulWidget {
  @override
  // final List<PlayerModel> players;
  // final void Function(PlayerModel player) onTapHandler;
  final PlayerLocationData? locationData;
  final Function(int index) onItemTapped;
  final int selectedIndex;

  const MyTabbedPage({
    Key? key,
    required this.locationData,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  _MyTabbedPageState createState() => _MyTabbedPageState(
      locationData: locationData,
      onItemTapped: onItemTapped,
      selectedIndex: selectedIndex);
}

class _MyTabbedPageState extends State<MyTabbedPage> {
  _MyTabbedPageState(
      {required this.locationData,
      required this.onItemTapped,
      required this.selectedIndex});

  // final List<PlayerModel> players;
  PlayerLocationData? locationData;
  Function(int index) onItemTapped;
  late List<Widget> widgetOptions;
  int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetOptions = <Widget>[
      locationData != null
          ? SearchPlayersForm(
              locationData: locationData!,
              onTapHandler: (p) {
                Navigator.of(context).pushNamed("/player/${p.id!}");
              },
            )
          : const Loading(text: "Загрузка"),
      locationData != null
          ? SearchCommunityForm(
              locationData: locationData!,
              onTapHandler: (p) {
                // Navigator.of(context).pushNamed("/player/${p.id!}");
              },
            )
          : const Loading(text: "Загрузка"),
      locationData != null
          ? SearchTrainersForm(
              locationData: locationData!,
              onTapHandler: (p) {
                // Navigator.of(context).pushNamed("/player/${p.id!}");
              },
            )
          : const Loading(text: "Загрузка"),
      locationData != null
          ? SearchCourtsForm(
              locationData: locationData!,
              onTapHandler: (p) {
                // Navigator.of(context).pushNamed("/player/${p.id!}");
              },
            )
          : const Loading(text: "Загрузка")
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
