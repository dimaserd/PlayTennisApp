import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/StickyHeaderList.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentCard.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';

class SearchTournamentsList extends StatefulWidget {
  final TournamentArgument tournamentArgument;

  const SearchTournamentsList({Key? key, required this.tournamentArgument})
      : super(key: key);

  @override
  State<SearchTournamentsList> createState() => _SearchTournamentsList();
}

class _SearchTournamentsList extends State<SearchTournamentsList> {
  final TextEditingController _searchController = TextEditingController();
  late List<TournamentSimpleModel> tournaments;
  bool isShowNothingFind = false;
  var count = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    setState(() {
      tournaments = widget.tournamentArgument.tournaments;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    var text = _searchController.text;
    setState(() {
      count = 1;
      isShowNothingFind = false;
      if (text.isEmpty) {
        tournaments = widget.tournamentArgument.tournaments;
      } else {
        tournaments = widget.tournamentArgument.tournaments.where((element) {
          var name = element.name ?? "";
          return name.toLowerCase().contains(text.toLowerCase());
        }).toList();
        if (tournaments.isEmpty) {
          setState(() {
            count = 2;
            isShowNothingFind = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.tournamentArgument.text)),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tournaments.length + count,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Поиск',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    );
                  } else {
                    if (isShowNothingFind) {
                      return const Text(
                        "По вашему запросу ничего не найдено",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF333A3B),
                            fontFamily: "OpenSans-Bold",
                            fontSize: 16),
                      );
                    } else {
                      return TournamentCard(
                        tournament: tournaments[index - 1],
                      );
                    }
                  }
                },
                physics: const AlwaysScrollableScrollPhysics(),
                controller: ScrollController()
                  ..addListener(() {
                    FocusScope.of(context).unfocus();
                  }),
              ),
            )
          ],
        ));
  }
}
