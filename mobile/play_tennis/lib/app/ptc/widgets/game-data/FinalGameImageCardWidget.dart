import 'dart:io';
import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';

class FinalGameImageCardWidget extends StatefulWidget {
  final Future<BaseApiResponse> Function() createClickHandler;
  final Function() goBackClickHandler;
  final Function() onSuccess;

  const FinalGameImageCardWidget({
    Key? key,
    required this.fileImage,
    required this.createClickHandler,
    required this.goBackClickHandler,
    required this.onSuccess,
  }) : super(key: key);

  final File? fileImage;

  @override
  State<FinalGameImageCardWidget> createState() =>
      _FinalGameImageCardWidgetState();
}

class _FinalGameImageCardWidgetState extends State<FinalGameImageCardWidget> {
  bool inProccess = false;
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            widget.fileImage != null
                ? Image.file(widget.fileImage!)
                : const Text(
                    "Вы создаете игру без фотографии",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            ...getWidgets()
          ],
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    if (inProccess) {
      return getInProccessWidgets();
    }

    return getNotInProccessWidgets();
  }

  List<Widget> getInProccessWidgets() {
    return [
      const Text(
        "Создаётся игра",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      )
    ];
  }

  List<Widget> getNotInProccessWidgets() {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: () async {
          if (inProccess) {
            return;
          }
          widget.createClickHandler().then((value) {
            BaseApiResponseUtils.handleResponse(context, value);

            setState(() {
              hasError = value.isSucceeded;
              inProccess = true;
            });

            if (value.isSucceeded) {
              widget.onSuccess();
            }
          });
        },
        child: const Text("Создать игру"),
      ),
      widget.fileImage == null
          ? Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  widget.goBackClickHandler();
                },
                child: const Text("Назад"),
              ),
            )
          : const SizedBox.shrink()
    ];
  }
}
