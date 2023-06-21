import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/services/TournamentPlayerService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

class JoinTournamentButton extends StatefulWidget {
  final int participationCostRub;
  final String tournamentId;

  const JoinTournamentButton({
    super.key,
    required this.participationCostRub,
    required this.tournamentId,
  });
  @override
  State<JoinTournamentButton> createState() => _JoinTournamentButton();
}

class _JoinTournamentButton extends State<JoinTournamentButton> {
  bool isHidePaymentButton = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isHidePaymentButton,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size.fromHeight(36),
        ),
        onPressed: () {
          clickHandler(context);
        },
        child: Text(
          "Записаться ${widget.participationCostRub}",
        ),
      ),
    );
  }

  clickHandler(BuildContext context) {
    AppServices.tournamentPlayerService.join(widget.tournamentId).then((value) {
      if (value.isSucceeded) {
        BaseApiResponseUtils.showSuccess(context, value.message);
      } else {
        if (value.responseObject!.errorType ==
            TournamentJoiningErrorType.NotEnoughMoney) {
          BaseApiResponseUtils.showError(context, value.message);
          var uri = Uri.parse(MainSettings.domain);
          launchUrl(uri);
        } else {
          setState(() {
            isHidePaymentButton = false;
          });
        }
      }
    });
  }
}
