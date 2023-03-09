import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
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
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          elevation: 4,
          child: ListTile(
            title: Text(
              "${tournament.name!} ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Column(
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
                RichText(
                  text: TextSpan(
                    text: "Перейти на сайт",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl();
                      },
                  ),
                ),
              ],
              // ),
            ),
          )),
    );
  }

  void _launchUrl() async {
    var url = "ptc/tournament/${tournament.id}";
    MainAppExtensions.trylaunchAppUrl(url, (p0) => null);
    //
  }
}
