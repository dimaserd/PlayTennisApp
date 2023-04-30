import 'dart:io';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/ImageInput.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/main-services.dart';

class AddGameImageWidget extends StatefulWidget {
  final Function(int fileId, File fileImage) imageReady;
  final Function() withoutImageClickHandler;

  const AddGameImageWidget({
    required this.imageReady,
    required this.withoutImageClickHandler,
    super.key,
  });

  @override
  State<AddGameImageWidget> createState() => _AddGameImageWidgetState();
}

class _AddGameImageWidgetState extends State<AddGameImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
          elevation: 5,
          child: Column(
            children: [
              ImageInput(
                saveImage: saveFile,
                useCropper: false,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(38),
              ),
              onPressed: () {
                widget.withoutImageClickHandler();
              },
              child: const Text("Продолжить без фотографии"),
            ),
          ),
        )
      ],
    );
  }

  Future<BaseApiResponse> saveFile(File file) async {
    var response = await AppServices.filesService.postFile(file);
    if (!response.isSucceeded || response.responseObject == null) {
      return BaseApiResponse(
        isSucceeded: false,
        message: "Произошла ошибка при загрузке файла изображения",
      );
    }
    var imagefileId = response.responseObject!.first;

    widget.imageReady(imagefileId, file);

    return BaseApiResponse(
      isSucceeded: true,
      message: "Фотография игры загружена",
    );
  }
}
