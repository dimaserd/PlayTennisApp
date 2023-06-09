import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/app/ptc/widgets/html/HtmlViewWidget.dart';
import 'package:play_tennis/main-extensions.dart';

class TournamentCard extends StatelessWidget {
  final TournamentSimpleModel tournament;
  const TournamentCard({
    super.key,
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onTapHandler(trainers[index]);
      },
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          elevation: 4,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: Text(
                      tournament.name!,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _launchUrl();
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  tournament.description != null
                      ? HtmlViewWidget(html: tournament.description!)
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 5,
                  ),
                ],
                // ),
              )
            ],
          )),
    );
  }

  void _launchUrl() async {
    var url = "ptc/tournament/${tournament.id}";
    MainAppExtensions.trylaunchAppUrl(url, (p0) => null);
  }
}
