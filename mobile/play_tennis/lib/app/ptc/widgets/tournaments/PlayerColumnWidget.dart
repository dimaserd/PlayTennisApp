import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class PlayerColumnWidget extends StatelessWidget {
  final PlayerSimpleModel player;

  const PlayerColumnWidget({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: PlayerAvatar(
            avatarFileId: player.avatarFileId,
          ),
        ),
        Text(
          "${player.surname!} ${player.name!}",
          style: const TextStyle(
            fontFamily: "OpenSans-Bold",
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
