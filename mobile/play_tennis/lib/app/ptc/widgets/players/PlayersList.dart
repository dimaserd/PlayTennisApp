import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';

class PlayersList extends StatelessWidget {
  List<PlayerModel> players;
  void Function(PlayerModel player) onTapHandler;
  void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  PlayersList({
    super.key,
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.players,
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
    return players.isEmpty
        ? Column(children: const [
            Center(
              child: Text("Игроки не найдены"),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == players.length) {
                if (isActiveLoader == false || players.length < 5) {
                  return Container();
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return GestureDetector(
                  onTap: () {
                    onTapHandler(players[index]);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    elevation: 4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: ListTile(
                      leading: PlayerAvatar(
                          avatarFileId: players[index].avatarFileId),
                      title: Text(
                        "${players[index].surname!} ${players[index].name!}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Ntrp: ${players[index].ntrpRating}"),
                          Text("Рейтинг силы: ${players[index].rating}")
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            itemCount: players.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
