import 'package:flutter/material.dart';
import 'CommonExampleRouteWrapper.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';

class HtmlImageViewWidget extends StatelessWidget {
  final String fileId;
  late final String mediumUrl;
  late final String originalUrl;

  HtmlImageViewWidget({super.key, required this.fileId}) {
    mediumUrl = '${MainSettings.domain}/FileCopies/Images/Medium/$fileId.jpg';
    originalUrl =
        '${MainSettings.domain}/FileCopies/Images/Original/$fileId.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Просмотр изображения"),
              ),
              body: CommonExampleRouteWrapper(
                imageProvider: NetworkImage(
                  originalUrl,
                ),
                loadingBuilder: (context, event) {
                  if (event == null) {
                    return const Center(
                      child: Text("Загрузка изображения"),
                    );
                  }

                  final value = event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

                  final percentage = (100 * value).floor();
                  return Center(
                    child: Loading(text: "Загрузка изображения $percentage%"),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: Image(
        image: NetworkImage(mediumUrl),
      ),
    );
  }
}
