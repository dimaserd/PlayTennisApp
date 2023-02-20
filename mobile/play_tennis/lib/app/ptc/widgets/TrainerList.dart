import 'package:flutter/material.dart';
import 'PlayerToSelect.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import '../../../logic/ptc/models/SearchPlayersRequest.dart';
import '../../../main.dart';
import 'CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';

class TrainerList extends StatelessWidget {
  List<TrainerCardSimpleModel> trainers;
  void Function(TrainerCardSimpleModel trainer) onTapHandler;
  void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  TrainerList({
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.trainers,
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
    return trainers.isEmpty
        ? Column(children: const [
            Center(
              child: Text("Тренеры не найдены"),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == trainers.length) {
                if (isActiveLoader == false || trainers.length < 5) {
                  return Container();
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return Center(child: CircularProgressIndicator());
                }
              } else {
                return GestureDetector(
                  onTap: () {
                    // onTapHandler(trainers[index]);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    elevation: 5,
                    child: ListTile(
                      leading: PlayerAvatar(
                          avatarFileId: null),
                      title: Text(
                        "${trainers[index].surname!} ${trainers[index].name!}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text("Ntrp: ${trainers[index].ntrpRating}"),
                          // Text("Рейтинг силы: ${trainers[index].rating}")
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            itemCount: trainers.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
