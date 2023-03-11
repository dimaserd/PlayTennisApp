import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/DropdownWidget.dart';

class CourtType {
  static String hard = "Hard";
  static String clay = "Clay";
  static String grass = "Grass";
}

class CourtTypeConsts {
  static final Map<String, String> texts = {
    CourtType.hard: "Хард",
    CourtType.clay: "Грунт",
    CourtType.grass: "Трава",
  };

  static DropdownWidgetItem hard =
      DropdownWidgetItem(label: texts[CourtType.hard]!, value: CourtType.hard);
  static DropdownWidgetItem clay =
      DropdownWidgetItem(label: texts[CourtType.clay]!, value: CourtType.clay);
  static DropdownWidgetItem grass = DropdownWidgetItem(
      label: texts[CourtType.grass]!, value: CourtType.grass);

  static DropdownWidgetItem getItem(String courtType) {
    if (courtType == CourtType.hard) {
      return CourtTypeConsts.hard;
    }

    if (courtType == CourtType.clay) {
      return CourtTypeConsts.clay;
    }

    if (courtType == CourtType.grass) {
      return CourtTypeConsts.grass;
    }

    throw Exception("$courtType не найден");
  }
}

class CourtTypeSelectController {
  String value = CourtTypeConsts.hard.value;
}

class CourtTypeSelect extends StatelessWidget {
  final CourtTypeSelectController controller;

  const CourtTypeSelect({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      label: "Тип покрытия",
      items: [
        CourtTypeConsts.hard,
        CourtTypeConsts.clay,
        CourtTypeConsts.grass,
      ],
      changedHandler: (p) {
        if (p != null) {
          controller.value = p.value;
        }
      },
      value: CourtTypeConsts.getItem(controller.value),
    );
  }
}
