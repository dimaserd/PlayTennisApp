import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class PlayerActions extends StatefulWidget {
  final PlayerModel player;
  final CurrentLoginData loginData;
  const PlayerActions({
    Key? key,
    required this.player,
    required this.loginData,
  }) : super(key: key);

  @override
  State<PlayerActions> createState() => _PlayerActionsState();
}

class _PlayerActionsState extends State<PlayerActions> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                onPressed: () {
                  if (widget.loginData.userId == widget.player.id) {
                    BaseApiResponseUtils.showError(
                        context, "Вы не можете внести игру против самого себя");
                    return;
                  }

                  Navigator.of(context)
                      .pushNamed('/create/game', arguments: widget.player);
                },
                child: const Text("Внести игру"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showError(String errorMessage) {
    BaseApiResponseUtils.showError(context, errorMessage);
  }
}
