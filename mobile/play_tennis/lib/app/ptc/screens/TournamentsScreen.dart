import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/SearchTournamentsForm.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/main-services.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  LocationData? locationData;

  void loadLocationData() {
    AppServices.playerService.getLocationData((e) => {}).then((value) {
      setState(() {
        locationData = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              isScrollable: false,
              tabs: [
                Tab(
                  text: "Однодневные",
                ),
                Tab(
                  text: "Многодневные",
                ),
              ],
            ),
            title: const Text('Турниры'),
          ),
          drawer: const SideDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TabBarView(
              children: getWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (locationData == null) {
      return [
        const Loading(text: "Однодневные турниры пока не реализованы"),
        const Loading(text: "Многодневные турниры пока не реализованы"),
      ];
    }

    return [
      SearchTournamentsForm(
        locationData: locationData!,
        onTapHandler: (trainer) {},
      ),
      const Loading(text: "Многодневные турниры пока не реализованы"),
    ];
  }
}
