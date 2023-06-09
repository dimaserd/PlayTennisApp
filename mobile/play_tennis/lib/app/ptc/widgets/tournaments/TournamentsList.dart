import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/TournamentCard.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/ShowAlertContact.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';

class TournamentsList extends StatelessWidget {
  List<TournamentSimpleModel> tournaments;
  final void Function(TournamentSimpleModel trainer) onTapHandler;
  final void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  TournamentsList({
    super.key,
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.tournaments,
    required this.getData,
  }) {
    addScrollListener();
  }

  final ScrollController _scrollController = ScrollController();

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offset += 10;
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() {
    getData(offset);
  }

  Widget getChild() {
    return tournaments.isEmpty
        ? Column(children: const [
            Center(
              child: Text(
                "По вашему запросу турниры не найдены",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == tournaments.length) {
                if (isActiveLoader == false || tournaments.length < 5) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ShowAlertContact(
                      title: "Создать турнир",
                      subTitle:
                          "Для того чтобы администрировать свои собственные турниры пожалуйста напишите мне.",
                    ),
                  );
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return TournamentCard(
                  tournament: tournaments[index],
                );
              }
            },
            itemCount: tournaments.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
