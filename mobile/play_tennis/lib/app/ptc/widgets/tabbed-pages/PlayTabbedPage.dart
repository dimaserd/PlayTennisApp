import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/communities/SearchCommunityForm.dart';
import 'package:play_tennis/app/ptc/widgets/courts/SearchCourtsForm.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/SearchTrainersForm.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';

class PlayTabbedPage extends StatefulWidget {
  final PlayerLocationData locationData;
  final Function(int index) onItemTapped;
  final int selectedIndex;

  const PlayTabbedPage({
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Заявки на игру"),
              Tab(text: "Мои заявки"),
            ],
          ),
          title: const Text('Играть'),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
