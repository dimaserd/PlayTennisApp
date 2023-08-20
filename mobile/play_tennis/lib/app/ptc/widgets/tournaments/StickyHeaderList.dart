import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentCard.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';

class StickyHeaderList extends StatelessWidget {
  const StickyHeaderList({
    Key? key,
    required this.tournaments,
    required this.text,
    required this.tournamentsRequest,
  }) : super(key: key);

  final String text;
  final List<TournamentSimpleModel> tournaments;
  final GetTournamentsRequest tournamentsRequest;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      sticky: false,
      header: SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF333A3B),
                fontFamily: "OpenSans-Bold",
                fontSize: 20,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                var argument =
                    TournamentArgument(text: text, tournaments: tournaments);
                Navigator.of(context)
                    .pushNamed(MainRoutes.tournamentAll, arguments: argument);
              },
              child: const Text(
                "Показать все",
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  fontFamily: "OpenSans-Bold",
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => TournamentCard(
            tournament: tournaments[i],
          ),
          childCount: tournaments.length,
        ),
      ),
    );
  }

  // TODO этот поиск турниров должен быть прокинут дальше в MainRoutes.tournamentAll
  void getActiveTournaments(BuildContext context) {
    tournamentsRequest.count = 20;
    tournamentsRequest.offSet =
        0; //Надо управлять offSet для подгрузки новых элементов
    AppServices.tournamentService.search(tournamentsRequest, (e) {
      BaseApiResponseUtils.showError(
          context, "Произошла ошибка при поиске турниров.");
    }).then((value) {
      //TODO Сделать подгрузку новых элементов
    });
  }
}

class TournamentArgument {
  final String text;

  //Сам список турниров прокидывать не надо нужно прокинуть tournamentsRequest
  final List<TournamentSimpleModel> tournaments;

  TournamentArgument({required this.text, required this.tournaments});
}
