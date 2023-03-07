import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ShowAlertAddTrainer.dart';

class TrainerList extends StatelessWidget {
  List<TrainerCardSimpleModel> trainers;
  void Function(TrainerCardSimpleModel trainer) onTapHandler;
  void Function(int offSet) getData;

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

  void _launchPhone(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await launchUrl(url)) {
      await launchUrl(url);
    }
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
                return GestureDetector(
                  onTap: () {
                    // onTapHandler(trainers[index]);
                  },
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 2),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          "${trainers[index].surname!} ${trainers[index].name!}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Номер телефона: ",
                                style: const TextStyle(color: mainColor),
                                children: [
                                  TextSpan(
                                    text: "${trainers[index].phoneNumber}",
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print("ta");
                                        _launchPhone(
                                            "${trainers[index].phoneNumber}");
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("${trainers[index].description}")
                          ],
                          // ),
                        ),
                      )),
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
