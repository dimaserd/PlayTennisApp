import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/main/widgets/side_drawer.dart';
import 'package:play_tennis/app/ptc/widgets/games/SearchMyGamesWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/app/main/widgets/ProfileData.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  PlayerData? playerData;
  CurrentLoginData? loginData;

  late TabController _tabController;
  var showButton = false;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    getPlayerData();
    getLoginData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {
        showButton = _tabController.index != 0;
        _index = _tabController.index;
      });
    }
  }

  void getPlayerData() {
    AppServices.playerService.getData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      if (mounted) {
        setState(() {
          playerData = value;
        });
      }
    });
  }

  void getLoginData() {
    AppServices.loginService.getLoginData().then((value) {
      if (mounted) {
        setState(() {
          loginData = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _index,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          drawer: const SideDrawer(),
          floatingActionButton: Visibility(
              visible: showButton,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/games/add');
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add),
              )),
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
              controller: _tabController,
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
              controller: _tabController,
              children: getWidgets(),
            ),
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
              child: ProfileData(player: playerData!, loginData: loginData),
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
