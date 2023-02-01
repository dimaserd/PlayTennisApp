import 'package:flutter/material.dart';
import '../../../../logic/ptc/models/PlayerModel.dart';

class GameFormExtensions {
  static List<Widget> getMatchText(
    BuildContext context,
    PlayerModel opponent,
    bool isWinning,
    String scoreText,
    List<Widget> customWidgets,
  ) {
    return [
      RichText(
        text: TextSpan(
          text: 'Вы ',
          style: DefaultTextStyle.of(context).style,
          children: getTextSpans(
            isWinning,
            opponent,
          ),
        ),
      ),
      RichText(
        text: TextSpan(
          text: scoreText,
          style: DefaultTextStyle.of(context).style,
        ),
      ),
      ...customWidgets,
      const SizedBox(
        height: 5,
      ),
    ];
  }

  static List<TextSpan> getTextSpans(
    bool isWinning,
    PlayerModel opponent,
  ) {
    var result = <TextSpan>[
      isWinning
          ? const TextSpan(
              text: 'победили ',
            )
          : const TextSpan(
              text: "проиграли ",
            ),
    ];

    result.add(TextSpan(
      text: "${opponent.surname!} ${opponent.name!} ",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ));

    result.add(const TextSpan(text: 'со счётом:'));

    return result;
  }
}
