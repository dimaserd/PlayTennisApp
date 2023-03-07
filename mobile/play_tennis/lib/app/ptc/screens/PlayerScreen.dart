import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/players/ShowPlayerData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/main-services.dart';

class PlayerScreen extends StatefulWidget {
  final String id;
  const PlayerScreen({super.key, required this.id});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PlayerModel? player;
  late bool loaded = false;

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getById(widget.id).then((value) {
      setState(() {
        loaded = true;
        player = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded && player != null
          ? ShowPlayerData(player: player!)
          : const Loading(text: "Игрок загружается"),
      appBar: AppBar(
        leading: const BackButton(),
        title: loaded
            ? Text("${player!.surname!} ${player!.name!}")
            : const Text("Загрузка игрока..."),
      ),
    );
  }
}
