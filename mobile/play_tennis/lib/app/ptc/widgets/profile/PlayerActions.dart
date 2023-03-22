import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class PlayerActions extends StatefulWidget {
  const PlayerActions({Key? key, required this.player}) : super(key: key,);
  final PlayerModel player;

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
                  Navigator.of(context).pushNamed('/create/game', arguments: widget.player);
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
