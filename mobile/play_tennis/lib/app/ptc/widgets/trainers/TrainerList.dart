import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/trainers/TrainerCard.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import 'ShowAlertAddTrainer.dart';

class TrainerList extends StatelessWidget {
  List<TrainerCardSimpleModel> trainers;
  final void Function(TrainerCardSimpleModel trainer) onTapHandler;
  final void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  TrainerList({
    super.key,
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
                  return const ShowAlertAddTrainer();
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return TrainerCard(
                  trainer: trainers[index],
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
