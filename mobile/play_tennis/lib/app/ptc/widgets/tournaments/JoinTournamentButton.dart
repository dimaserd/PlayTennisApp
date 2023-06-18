import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/services/TournamentPlayerService.dart';
import 'package:play_tennis/main-services.dart';

class JoinTournamentButton extends StatelessWidget {
  final int participationCostRub;
  final String tournamentId;
  const JoinTournamentButton({
    super.key,
    required this.participationCostRub,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size.fromHeight(36),
      ),
      onPressed: () {
        clickHandler(context);
      },
      child: Text(
        "Записаться $participationCostRub₽",
      ),
    );
  }

  clickHandler(BuildContext context) {
    AppServices.tournamentPlayerService.join(tournamentId).then((value) {
      if (!value.isSucceeded) {
        BaseApiResponseUtils.showError(context, value.message);
      } else {
        BaseApiResponseUtils.showSuccess(context, value.message);

        if (value.responseObject!.errorType ==
            TournamentJoiningErrorType.NotEnoughMoney) {
          //Показать голубую кнопку (Пополнить баланс) эта кнопка откроет браузер
        } else {
          //TODO Скрыть кнопку
        }
      }
    });
  }
}
