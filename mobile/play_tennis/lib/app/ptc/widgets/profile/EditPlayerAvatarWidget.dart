import 'dart:io';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/ImageInput.dart';
import 'package:play_tennis/app/main/widgets/images/PlayerAvatar.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/main-services.dart';

class EditPlayerAvatarWidget extends StatefulWidget {
  int? avatarFileId;
  EditPlayerAvatarWidget({super.key, required this.avatarFileId});

  @override
  State<EditPlayerAvatarWidget> createState() => _EditPlayerAvatarWidgetState();
}

class _EditPlayerAvatarWidgetState extends State<EditPlayerAvatarWidget> {
  bool isEdit = false;
  bool completed = false;

  List<Widget> getCompletedWidgets() {
    return [
      const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Аватар обновлен вернитесь назад",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      )
    ];
  }

  List<Widget> getProccessWidgets() {
    return [
      !isEdit
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: PlayerAvatar(
                avatarFileId: widget.avatarFileId,
              ),
            )
          : const SizedBox.shrink(),
      !isEdit
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(30),
                ),
                onPressed: (() {
                  setState(() {
                    isEdit = true;
                  });
                }),
                child: const Text(
                  "Выбрать новый аватар",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      isEdit
          ? ImageInput(
              saveImage: saveFile,
              useCropper: true,
              labelText: "Выбрать новое изображение для аватара",
            )
          : const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: completed ? getCompletedWidgets() : getProccessWidgets(),
    );
  }

  Future<BaseApiResponse> saveFile(File file) async {
    var response = await AppServices.filesService.postFile(file);
    if (!response.isSucceeded) {
      return BaseApiResponse(
          isSucceeded: false, message: "Произошла ошибка при загрузке файла");
    }
    var newAvatarFileId = response.responseObject.first;

    var avatarResponse =
        await AppServices.clientService.updatePhoto(newAvatarFileId);

    if (avatarResponse.isSucceeded) {
      setState(() {
        widget.avatarFileId = newAvatarFileId;
        isEdit = false;
      });
      return BaseApiResponse(isSucceeded: true, message: "Ваш аватар обновлен");
    }

    return BaseApiResponse(
        isSucceeded: false, message: "Произошла ошибка при смене аватара");
  }
}
