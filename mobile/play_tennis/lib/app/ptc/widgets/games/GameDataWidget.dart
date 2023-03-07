import 'package:flutter/material.dart';
import '../../../../baseApiResponseUtils.dart';
import '../../../../logic/ptc/models/games/TennisSetData.dart';
import '../../../main/widgets/Inputs/SetInput.dart';
import 'package:play_tennis/logic/ptc/models/GamePlayers.dart';

class GameDataWidgetExtensions {
  static String getStringValue(List<TennisSetData> value) {
    var str = "";

    for (var i = 0; i < value.length; i++) {
      var setData = value[i];
      str += "${setData.score1}:${setData.score2}";

      if (i != value.length - 1) {
        str += " ";
      }
    }

    return str;
  }

  static GamePlayers getStringValueGames(
      List<TennisSetData> value, int numberPlayer) {
    GamePlayers game =
        GamePlayers(firstGame: "-", secondGame: "-", thirdGame: "-");

    for (var i = 0; i < value.length; i++) {
      var setData = value[i];
      var score = numberPlayer == 0 ? setData.score1 : setData.score2;
      var correctScore = score?.isEmpty ?? true ? "-" : score!;
      switch (i) {
        case 0:
          game.firstGame = correctScore;
          break;
        case 1:
          game.secondGame = correctScore;
          break;
        case 2:
          game.thirdGame = correctScore;
          break;
        case 3:
          break;
        default:
          break;
      }
    }
    return game;
  }
}

class GameDataWidgetController {
  int _setCount = 1;

  final List<TextEditingController> setTextEditingControllers = [
    TextEditingController(text: "0:0"),
    TextEditingController(text: "0:0"),
    TextEditingController(text: "0:0"),
    TextEditingController(text: "0:0"),
    TextEditingController(text: "0:0"),
  ];

  setSetCount(int setCount) {
    _setCount = setCount;
  }

  bool isWinning() {
    var value = getValue();
    int score1 = 0;
    int score2 = 0;
    for (var i = 0; i < value.length; i++) {
      var setData = value[i];

      if (isWinningSetData(setData)) {
        score1++;
      } else {
        score2++;
      }
    }

    return score1 > score2;
  }

  bool isWinningSetData(TennisSetData setData) {
    var setScore1 = int.parse(setData.score1 ?? "0");
    var setScore2 = int.parse(setData.score2 ?? "0");

    return setScore1 > setScore2;
  }

  bool isValidMatchData(
    Function(String) onError,
  ) {
    var value = getValue();

    var setScore1 = 0;
    var setScore2 = 0;

    for (var i = 0; i < value.length; i++) {
      var setData = value[i];

      if (!isValidSetData(setData, i, onError)) {
        return false;
      }

      if (isWinningSetData(setData)) {
        setScore1++;
      } else {
        setScore2++;
      }
    }

    if (setScore1 == setScore2) {
      onError("Неправильно указан счёт в матче. Очки сета равны.");
      return false;
    }

    return true;
  }

  bool isValidSetData(
    TennisSetData setData,
    int setNum,
    Function(String) onError,
  ) {
    int? score1Null = int.tryParse(setData.score1!);
    int? score2Null = int.tryParse(setData.score2!);

    if (score1Null == null || score2Null == null) {
      onError("Неправильно указан счёт в ${setNum + 1} сете");
      return false;
    }

    int score1 = score1Null;
    int score2 = score2Null;

    if (score1 == score2) {
      onError(
          "Неправильно указан счёт в ${setNum + 1} сете. Равное количество геймов.");
      return false;
    }

    if (score1 < 0 || score2 < 0) {
      onError(
          "Неправильно указан счёт в ${setNum + 1} сете. Отрицательное число в одном из геймов.");
      return false;
    }

    if (score1 > 7 || score2 > 7) {
      onError(
          "Неправильно указан счёт в ${setNum + 1} сете. В одном из геймов указано более 7 очков.");
      return false;
    }

    if (score1 < 6 && score2 < 6) {
      onError("Неправильно указан счёт в ${setNum + 1} сете. 2");
      return false;
    }

    if (score1 == 7 && score2 != 6) {
      onError("Неправильно указан счёт в ${setNum + 1} сете. 3");
      return false;
    }

    if (score1 != 6 && score2 == 7) {
      onError("Неправильно указан счёт в ${setNum + 1} сете. 4");
      return false;
    }

    return true;
  }

  String getStringValue() {
    var value = getValue();

    return GameDataWidgetExtensions.getStringValue(value);
  }

  List<TennisSetData> getValue() {
    List<TennisSetData> list = [];

    for (var i = 0; i < _setCount; i++) {
      list.add(getSetValue(i));
    }

    return list;
  }

  TennisSetData getSetValue(int i) {
    var text = setTextEditingControllers[i].text;

    var bits = text.split(':');
    var value1 = bits.first;
    var value2 = bits.last;

    return TennisSetData(
      score1: value1,
      score2: value2,
      tieBreak: TennisTieBreakScoreData(
        score1: "",
        score2: "",
      ),
    );
  }
}

class GameDataWidget extends StatefulWidget {
  final GameDataWidgetController controller;

  const GameDataWidget({super.key, required this.controller});

  @override
  State<GameDataWidget> createState() => _GameDataWidgetState();
}

class _GameDataWidgetState extends State<GameDataWidget> {
  int setSize = 0;

  @override
  void initState() {
    setSize = widget.controller._setCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...getSets(context),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {
                    if (setSize == 5) {
                      BaseApiResponseUtils.showError(
                          context, "Вы пытаетесь создать шестой сет");
                      return;
                    }
                    setState(() {
                      setSize++;
                    });
                    widget.controller._setCount = setSize;
                  },
                  child: const Text("Добавить сет"),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  onPressed: () {
                    if (setSize == 1) {
                      BaseApiResponseUtils.showError(
                          context, "Вы пытаетесь удалить единственный сет");
                      return;
                    }
                    setState(() {
                      setSize--;
                    });
                    widget.controller._setCount = setSize;
                  },
                  child: const Text("Удалить нижний"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getSets(BuildContext context) {
    List<Widget> result = [];

    for (int i = 0; i < setSize; i++) {
      result.add(getSet(context, i));
    }

    return result;
  }

  Widget getSet(BuildContext context, int setNumber) {
    return SetInput(
      labelText: "${setNumber + 1} сет",
      textController: widget.controller.setTextEditingControllers[setNumber],
    );
  }
}
