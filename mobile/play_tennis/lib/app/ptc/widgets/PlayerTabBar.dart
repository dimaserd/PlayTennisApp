import 'package:flutter/material.dart';
import '../../../logic/ptc/models/PlayerModel.dart';
import 'PlayersList.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'SearchPlayersForm.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../main/widgets/Loading.dart';

class MyTabbedPage extends StatefulWidget {
  @override
  // final List<PlayerModel> players;
  // final void Function(PlayerModel player) onTapHandler;
  final PlayerLocationData? locationData;

  const MyTabbedPage({
    Key? key,
    required this.locationData,
  }) : super(key: key);

  _MyTabbedPageState createState() =>
      _MyTabbedPageState(locationData: locationData);
}

class _MyTabbedPageState extends State<MyTabbedPage> {
  int _selectedIndex = 0;

  _MyTabbedPageState({required this.locationData});

  // final List<PlayerModel> players;
  PlayerLocationData? locationData;
  late List<Widget> widgetOptions;

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
      Text('Сообщества'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          iconSize: 20,
          backgroundColor: Colors.transparent,
          showElevation: false,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          containerHeight: 50,
          selectedIndex: _selectedIndex,
          onItemSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
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
                activeColor: Colors.blue),
          ]),
      resizeToAvoidBottomInset: false,
    );
  }
}

