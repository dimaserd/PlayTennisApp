import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/logic/ptc/services/CourtCardService.dart';
import 'package:url_launcher/url_launcher.dart';

class CourtsList extends StatelessWidget {
  List<CourtCardSimpleModel> courts;
  void Function(CourtCardSimpleModel trainer) onTapHandler;
  void Function(int offSet) getData;

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

  void _launchPhone(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await launchUrl(url)) {
      await launchUrl(url);
    }
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
                          courts[index].name!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Номер телефона: ",
                                style: const TextStyle(color: mainColor),
                                children: [
                                  TextSpan(
                                    text: "+79166044960 фейк",
                                    style: const TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print("ta");
                                        _launchPhone("+79166044960");
                                      },
                                  ),
                                ],
                              ),
                            ),
                            Text("${courts[index].description}")
                          ],
                          // ),
                        ),
                      )),
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
