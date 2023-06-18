import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-services.dart';

class LeaveTournamentButton extends StatelessWidget {
  final int participationCostRub;
  final String tournamentId;
  const LeaveTournamentButton({
    super.key,
    required this.participationCostRub,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size.fromHeight(36),
      ),
      onPressed: () {
        clickHandler(context);
      },
      child: const Text(
        "Покинуть турнир",
      ),
    );
  }

  clickHandler(BuildContext context) {
    AppServices.tournamentPlayerService.leave(tournamentId).then((value) {
      if (!value.isSucceeded) {
        BaseApiResponseUtils.showError(context, value.message);
      } else {
        BaseApiResponseUtils.showSuccess(context, value.message);

        //TODO Скрыть кнопку
      }
    });
  }
}
