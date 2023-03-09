import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          padding: const EdgeInsets.all(20.0),
          child: TabBarView(
            children: getWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      const Loading(text: "Однодневные турниры пока не реализованы"),
      const Loading(text: "Многодневные турниры пока не реализованы"),
    ];
  }
}
