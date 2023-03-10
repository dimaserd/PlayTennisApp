import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/profile_data.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/games/SearchMyGamesWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/main-services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  PlayerData? playerData;
  CurrentLoginData? loginData;

  @override
  void initState() {
    super.initState();
    getPlayerData();
    getLoginData();
  }

  void getPlayerData() {
    AppServices.playerService.getData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      setState(() {
        playerData = value;
      });
    });
  }

  void getLoginData() {
    AppServices.loginService.getLoginData().then((value) {
      setState(() {
        loginData = value;
      });
    });
  }

  bool showFloat = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const SideDrawer(),
        floatingActionButton: showFloat
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/games/add');
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add),
              )
            : null,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile-edit");
              },
              icon: const Icon(Icons.edit),
            )
          ],
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                showFloat = value == 1;
              });
            },
            tabs: const [
              Tab(
                text: "Данные",
              ),
              Tab(
                text: "Мои игры",
              ),
            ],
          ),
          title: const Text("Профиль"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: TabBarView(
            children: getWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (playerData == null || loginData == null) {
      return const [
        Loading(text: "Загрузка"),
        Loading(text: "Загрузка"),
      ];
    }

    return [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ProfileData(player: playerData!),
            ),
          ],
        ),
      ),
      Column(
        children: [
          SearchMyGamesWidget(
            loginData: loginData!,
          ),
        ],
      ),
    ];
  }
}
