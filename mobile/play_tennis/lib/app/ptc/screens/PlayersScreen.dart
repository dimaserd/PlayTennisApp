import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import '../../../logic/ptc/models/PlayerLocationData.dart';
import '../../../main.dart';
import '../../main/widgets/Loading.dart';
import '../../main/widgets/side_drawer.dart';
import '../widgets/SearchPlayersForm.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  PlayerLocationData? locationData;

  @override
  void initState() {
    super.initState();
    MyApp.playerService.getLocationData().then((value) {
      if (value == null) {
        BaseApiResponseUtils.showError(context, "Кажется вы были разлогинены");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => true);
        return;
      }
      setState(() {
        locationData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: locationData != null
            ? SearchPlayersForm(
                locationData: locationData!,
                onTapHandler: (p) {
                  Navigator.of(context).pushNamed("/player/${p.id!}");
                },
              )
            : const Loading(text: "Загрузка"),
      ),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Игроки"),
      ),
    );
  }
}
