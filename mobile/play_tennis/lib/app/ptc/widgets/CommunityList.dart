import 'package:flutter/material.dart';
import 'PlayerToSelect.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import '../../../main.dart';
import 'CountryAndCitySelectWidget.dart';
import '../../../logic/ptc/services/CommunityCardService.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';

class CommunityList extends StatelessWidget {
  List<CommunityCardSimpleModel> community;
  void Function(SearchCommunityCards community) onTapHandler;
  void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  CommunityList({
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.community,
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
    return community.isEmpty
        ? Column(children: const [
            Center(
              child: Text("Сообщества не найдены"),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == community.length) {
                if (isActiveLoader == false || community.length < 5) {
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
                          avatarFileId: 63),
                      title: Text(
                        "${community[index].name!}",
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
            itemCount: community.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
