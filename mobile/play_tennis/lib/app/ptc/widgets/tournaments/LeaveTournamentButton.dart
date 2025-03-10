import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main-services.dart';

class LeaveTournamentButton extends StatefulWidget {
  final int participationCostRub;
  final String tournamentId;

  const LeaveTournamentButton({
    super.key,
    required this.participationCostRub,
    required this.tournamentId,
  });

  @override
  State<LeaveTournamentButton> createState() => _LeaveTournamentButton();
}

class _LeaveTournamentButton extends State<LeaveTournamentButton> {
  bool isHidePaymentButton = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isHidePaymentButton,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size.fromHeight(36),
        ),
        onPressed: () {
          clickHandler(context);
        },
        child: const Text(
          "Покинуть турнир",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  clickHandler(BuildContext context) {
    AppServices.tournamentPlayerService
        .leave(widget.tournamentId)
        .then((value) {
      if (value.isSucceeded) {
        BaseApiResponseUtils.showSuccess(context, value.message);
      } else {
        BaseApiResponseUtils.showError(context, value.message);
        setState(() {
          isHidePaymentButton = false;
        });
      }
    });
  }
}
