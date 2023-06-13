import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/notifications/SearchNotificationsForm.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/main-services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
                  text: "Уведомления",
                ),
                Tab(
                  text: "Чаты",
                ),
              ],
            ),
            title: const Text('Уведомления'),
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
        const Loading(text: "Загрузка"),
        const Loading(text: "Загрузка"),
      ];
    }

    return [
      SearchNotificationsForm(
        locationData: locationData!,
      ),
      Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Чаты пока не реализованы",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedCircleLoading(height: MediaQuery.of(context).size.width),
        ],
      ),
    ];
  }
}
