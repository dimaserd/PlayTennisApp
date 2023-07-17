import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/courts/CourtTypeSelect.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormCourtDataWidget.dart';

class AboutCourtTextDataWidget extends StatelessWidget {
  const AboutCourtTextDataWidget({
    super.key,
    required this.courtData,
    required this.courtName,
    required this.courtType,
  });

  final GameFormCourtData? courtData;
  final String courtName;
  final String courtType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Страна: ${courtData!.selectedCountry.name}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Город: ${courtData!.selectedCity.name}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Корт: $courtName",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Покрытие: ${CourtTypeConsts.texts[courtType]}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
