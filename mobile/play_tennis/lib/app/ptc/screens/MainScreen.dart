import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/communities/SearchCommunityForm.dart';
import 'package:play_tennis/app/ptc/widgets/courts/SearchCourtsForm.dart';
import 'package:play_tennis/app/ptc/widgets/players/SearchPlayersForm.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/SearchTrainersForm.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/web-app-routes.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LocationData? locationData;
  StreamSubscription? _sub;

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
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) {
      return;
    }

    _sub?.cancel();
    _sub = uriLinkStream.listen(
      (Uri? uri) {
        print(uri);
        if (uri != null) {
          var path = uri.path;

          var matchResult = WebAppRoutes.match(path);

          if (matchResult.succeeded) {
            Navigator.of(context).pushNamed(matchResult.appRoute);
            return;
          } else {
            launchUrl(uri);
          }
        }
      },
      onError: (err) {
        print('Failed to get link stream: $err');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Главная"),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: "Игроки",
                ),
                Tab(
                  text: "Сообщества",
                ),
                Tab(
                  text: "Тренеры",
                ),
                Tab(
                  text: "Корты",
                ),
              ],
            ),
          ),
          drawer: const SideDrawer(),
          body: TabBarView(
            children: getWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (locationData == null) {
      return [
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
        AnimatedCircleLoading(
          height: MediaQuery.of(context).size.width,
        ),
      ];
    }

    return [
      SearchPlayersForm(
        locationData: locationData!,
        onTapHandler: (p) {
          MainRoutes.toPlayerCard(context, p.id!);
        },
      ),
      SearchCommunityForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchTrainersForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      ),
      SearchCourtsForm(
        locationData: locationData!,
        onTapHandler: (p) {
          // Navigator.of(context).pushNamed("/player/${p.id!}");
        },
      )
    ];
  }
}
