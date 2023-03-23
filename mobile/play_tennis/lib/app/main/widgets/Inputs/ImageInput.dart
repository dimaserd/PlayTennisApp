import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/main.dart';
import 'package:play_tennis/utils.dart';

class ImageInput extends StatefulWidget {
  final String labelText;
  final Future<BaseApiResponse> Function(File file) saveImage;
  final bool useCropper;

  const ImageInput({
    super.key,
    required this.saveImage,
    required this.useCropper,
    this.labelText = "Выберите изображение",
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? image;

  bool inProcess = false;

  Future pickImage(bool isGallery, Function(String err) errorHandler) async {
    if (MyApp.inProccess) {
      errorHandler("Процесс выбора изображения уже запущен.");
      return;
    }

    MyApp.inProccess = true;
    try {
      final image = await Utils.pickMedia(
        isGallery: isGallery,
        cropImage: widget.useCropper ? Utils.cropSquareImage : null,
      );

      if (image == null) {
        errorHandler("Не удалось выбрать изображение. NullRef");
        MyApp.inProccess = false;
        return;
      }

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      errorHandler('Не удалось выбрать изображение. $e');
    } on Exception catch (e) {
      errorHandler('Не удалось выбрать изображение. $e');
    } finally {
      MyApp.inProccess = false;
    }
  }

  Future<BaseApiResponse> saveImage() async {
    MyApp.inProccess = true;

    setState(() {
      inProcess = true;
    });
    var response = await widget.saveImage(image!);
    setState(() {
      inProcess = false;
    });

    MyApp.inProccess = false;

    return response;
  }

  List<Widget> getSelectImageWidgets() {
    if (image != null) {
      return [const SizedBox.shrink()];
    }

    return [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          widget.labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size.fromHeight(36),
          ),
          onPressed: (() async {
            await pickImage(true, _errorHandler);
          }),
          child: const Text(
            "из галереи",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size.fromHeight(36),
          ),
          onPressed: (() async {
            await pickImage(false, _errorHandler);
          }),
          child: const Text(
            "с камеры",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }

  void _errorHandler(String message) {
    BaseApiResponseUtils.showError(context, message);
  }

  List<Widget> getUploadImageButtons() {
    if (image == null) {
      return [const SizedBox.shrink()];
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: inProcess
            ? const Loading(text: "Изображение загружается на сервер")
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(36),
                ),
                onPressed: (() {
                  if (MyApp.inProccess) {
                    return;
                  }
                  saveImage().then((response) {
                    BaseApiResponseUtils.handleResponse(context, response);
                  });
                }),
                child: const Text(
                  "Загрузить",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size.fromHeight(36),
          ),
          onPressed: (() {
            setState(() {
              image = null;
            });
          }),
          child: const Text(
            "Отмена",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ...getSelectImageWidgets(),
          const SizedBox(
            height: 20,
          ),
          image != null
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(image!),
                )
              : const Text("Изображение не выбрано"),
          const SizedBox(
            height: 20,
          ),
          ...getUploadImageButtons(),
        ],
      ),
    );
  }
}
