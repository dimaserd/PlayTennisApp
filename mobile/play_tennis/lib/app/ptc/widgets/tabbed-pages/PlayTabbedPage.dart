import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Tabs Demo'),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
