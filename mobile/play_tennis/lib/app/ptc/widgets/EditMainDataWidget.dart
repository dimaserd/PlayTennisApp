import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/main.dart';
import '../../../logic/ptc/models/PlayerData.dart';
import '../../../logic/ptc/models/players/UpdateDataByPlayerRequest.dart';
import '../../main/widgets/Inputs/DatePickerInput.dart';
import '../../main/widgets/Inputs/DropdownWidget.dart';
import '../../main/widgets/Inputs/TextInput.dart';

class EditMainDataWidget extends StatefulWidget {
  PlayerData playerData;
  late TextEditingController surnameTextController;
  late TextEditingController nameTextController;
  late TextEditingController patronymicTextController;
  late TextEditingController aboutMeTextController;
  late DateTime birthDate;
  late DropdownWidgetItem selectedSex;
  EditMainDataWidget({super.key, required this.playerData}) {
    surnameTextController = TextEditingController(text: playerData.surname);
    nameTextController = TextEditingController(text: playerData.name);
    patronymicTextController =
        TextEditingController(text: playerData.patronymic);
    aboutMeTextController = TextEditingController(text: playerData.aboutMe);
    birthDate = playerData.birthDate;
    selectedSex = DropdownWidgetItem(
      label: playerData.sex ? "Мужской" : "Женский",
      value: playerData.sex.toString().toLowerCase(),
    );
  }

  @override
  State<EditMainDataWidget> createState() => _EditMainDataWidgetState();
}

class _EditMainDataWidgetState extends State<EditMainDataWidget> {
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: TextInput(
            labelText: "Фамилия",
            textController: widget.surnameTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: TextInput(
            labelText: "Имя",
            textController: widget.nameTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: TextInput(
            labelText: "Отчество",
            textController: widget.patronymicTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: DropdownWidget(
            label: "Пол",
            items: [
              DropdownWidgetItem(
                label: "Мужской",
                value: true.toString().toLowerCase(),
              ),
              DropdownWidgetItem(
                label: "Женский",
                value: false.toString().toLowerCase(),
              ),
            ],
            changedHandler: (p) {
              if (p != null) {
                widget.selectedSex = p;
              }
            },
            value: widget.selectedSex,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: DatePickerInput(
            label: "Дата рождения",
            dateChanged: (p) {
              if (p != null) {
                widget.birthDate = p;
              }
            },
            defaultValue: widget.birthDate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: TextAreaInput(
            labelText: "Обо мне",
            maxLines: 3,
            textController: widget.aboutMeTextController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15.0,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(40), // NEW
            ),
            onPressed: clickHandler,
            child: const Text("Сохранить"),
          ),
        ),
        const SizedBox(
          height: 6,
        )
      ],
    );
  }

  Future clickHandler() async {
    if (isBusy) {
      return;
    }

    isBusy = true;

    var data = UpdateDataByPlayerRequest(
      name: widget.nameTextController.text,
      surname: widget.surnameTextController.text,
      patronymic: widget.patronymicTextController.text,
      aboutMe: widget.aboutMeTextController.text,
      birthDate: widget.birthDate,
      sex: widget.selectedSex.value == true.toString().toLowerCase(),
    );

    MyApp.playerService.updateData(data).then((value) {
      BaseApiResponseUtils.handleResponse(context, value);
      isBusy = false;
    });
  }
}
