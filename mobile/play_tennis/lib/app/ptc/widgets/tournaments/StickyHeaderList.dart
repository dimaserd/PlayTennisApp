import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentCard.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class StickyHeaderList extends StatelessWidget {
  const StickyHeaderList(
      {Key? key, required this.tournaments, required this.text})
      : super(key: key);

  final String text;
  final List<TournamentSimpleModel> tournaments;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      sticky: false,
      header: SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: const TextStyle(
                    color: Color(0xFF333A3B),
                    fontFamily: "OpenSans-Bold",
                    fontSize: 20)),
          )),
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
}
