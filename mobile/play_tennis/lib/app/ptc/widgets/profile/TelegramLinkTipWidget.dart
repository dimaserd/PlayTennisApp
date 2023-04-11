import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';

class TelegramLinkTipWidget extends StatelessWidget {
  final PlayerData player;
  const TelegramLinkTipWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.blueAccent,
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Привяжите вашу учетную запись телеграм",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
