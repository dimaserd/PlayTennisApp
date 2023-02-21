import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../logic/ptc/services/CommunityCardService.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

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
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        "${community[index].name!}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              var url =
                                  Uri.parse("${community[index].telegramLink}");
                              launchUrl(url);
                            },
                            child: Text(
                              "Ссылка на телеграм",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text("${community[index].description}")
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
