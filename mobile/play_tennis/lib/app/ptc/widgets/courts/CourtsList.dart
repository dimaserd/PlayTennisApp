import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/courts/CourtCard.dart';
import 'package:play_tennis/logic/ptc/services/CourtCardService.dart';

class CourtsList extends StatelessWidget {
  final List<CourtCardSimpleModel> courts;
  final void Function(CourtCardSimpleModel trainer) onTapHandler;
  final void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  CourtsList({
    super.key,
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.courts,
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
    return courts.isEmpty
        ? Column(children: const [
            Center(
              child: Text("Корты не найдены"),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == courts.length) {
                if (isActiveLoader == false || courts.length < 5) {
                  return Container();
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return CourtCard(
                  courtCard: courts[index],
                );
              }
            },
            itemCount: courts.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
