import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../logic/clt/models/BaseApiResponse.dart';
import '../../../../main.dart';
import '../../../main/widgets/Inputs/ImageInput.dart';

class AddGameImageWidget extends StatefulWidget {
  final Function(int fileId, File fileImage) imageReady;
  final Function() noImage;

  const AddGameImageWidget({
    required this.imageReady,
    required this.noImage,
    super.key,
  });

  @override
  State<AddGameImageWidget> createState() => _AddGameImageWidgetState();
}

class _AddGameImageWidgetState extends State<AddGameImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      elevation: 5,
      child: Column(
        children: [
          ImageInput(
            saveImage: saveFile,
          ),
        ],
      ),
    );
  }

  Future<BaseApiResponse> saveFile(File file) async {
    var response = await MyApp.filesService.postFile(file);
    if (!response.isSucceeded) {
      return BaseApiResponse(
        isSucceeded: false,
        message: "Произошла ошибка при загрузке файла изображения",
      );
    }
    var imagefileId = response.responseObject.first;

    widget.imageReady(imagefileId, file);

    return BaseApiResponse(
      isSucceeded: true,
      message: "Фотография игры загружена",
    );
  }
}
