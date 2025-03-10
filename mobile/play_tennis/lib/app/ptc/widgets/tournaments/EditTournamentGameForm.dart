import 'dart:io';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/CustomDateAndTimePickerWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/AddGameImageWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/FinalGameImageCardWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/courts/CourtTypeSelect.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormCourtDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameSetScores.dart';
import 'package:play_tennis/app/ptc/widgets/tournaments/PlayerColumnWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/logic/ptc/models/PlayerSetScores.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CountrySimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/TournamentGameService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class TournamentGameData {
  String courtType;
  String courtName;
  List<TennisSetData> score;
  CityModel courtCity;
  CountrySimpleModel courtCountry;
  bool isWinning;
  DateTime gameDate;
  int? imageFileId;
  GameSetScoresModel gameScores;

  TournamentGameData({
    required this.courtType,
    required this.courtName,
    required this.score,
    required this.courtCity,
    required this.courtCountry,
    required this.isWinning,
    required this.imageFileId,
    required this.gameDate,
    required this.gameScores,
  });
}

enum ScrollDirection { top, bottom }

class EditTournamentGameForm extends StatefulWidget {
  final Future<BaseApiResponse> Function(TournamentGameData) createGameClick;
  final Function() onSuccess;
  final TournamentGameDetailedModel game;

  const EditTournamentGameForm({
    Key? key,
    required this.createGameClick,
    required this.onSuccess,
    required this.game,
  }) : super(key: key);

  @override
  State<EditTournamentGameForm> createState() => _EditTournamentGameFormState();
}

class _EditTournamentGameFormState extends State<EditTournamentGameForm> {
  PlayerLocationData? locationData;

  GameDataWidgetController gameDataWidgetController =
      GameDataWidgetController();

  CustomDateAndTimePickerWidgetController dateAndTimePickerController =
      CustomDateAndTimePickerWidgetController(
    value: CustomDateAndTimePickerWidgetData.now(),
  );

  CountryAndCitySelectController countryAndCitySelectController =
      CountryAndCitySelectController();

  TextEditingController courtNameController = TextEditingController();
  CourtTypeSelectController courtTypeSelectController =
      CourtTypeSelectController();
  final ScrollController _scrollController = ScrollController();

  int step = 0;
  bool hasScore = false;
  int? imageFileId;
  File? fileImage;
  GameFormCourtData? courtData;

  void onGameDataChanged() {
    return;
  }

  @override
  void initState() {
    super.initState();
    AppServices.playerService.getPlayerLocationData((e) => {}).then((value) {
      if (value != null) {
        countryAndCitySelectController.city = value.city;
        countryAndCitySelectController.setCountry(value.country!);
      }
      if (mounted) {
        setState(() {
          locationData = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locationData == null) {
      return ConstrainedBox(
        key: UniqueKey(), // добавлен ключ
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: const SizedBox(
          child: Column(
            children: [
              Loading(text: "Загрузка"),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getStepWidgets(),
          ),
        ),
      ),
    );
  }

  void setOpponent(PlayerModel player) {
    if (mounted) {
      setState(() {
        step = 1;
      });
    }
  }

  List<Widget> getStepWidgets() {
    if (step == 0) {
      return [
        showPlayers(),
        const SizedBox(
          height: 5,
        ),
        !hasScore
            ? GestureDetector(
                onVerticalDragDown: (_) {
                  FocusScope.of(context).unfocus();
                },
                child: Card(
                  margin: const EdgeInsets.only(
                    top: 0,
                    left: 0,
                    right: 0,
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text(
                          "Счёт матча",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GameDataWidget(controller: gameDataWidgetController),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: _saveScore,
                          child: const Text(
                            "Далее",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 10,
        ),
      ];
    }

    if (step == 1) {
      return [
        showScore(),
        const SizedBox(
          height: 10,
        ),
        GameFormCourtDataWidget(
          label: "Укажите время и место игры:",
          countryAndCitySelectController: countryAndCitySelectController,
          errorHandler: _errorHandler,
          successHandler: _gameFormCourtDataWidgetHandler,
          dateAndTimePickerController: dateAndTimePickerController,
          courtNameController: courtNameController,
          courtTypeSelectController: courtTypeSelectController,
          scroll: () {
            scrollMove(ScrollDirection.bottom);
          },
        ),
        const SizedBox(
          height: 190,
        ),
      ];
    }

    if (step == 2) {
      scrollMove(ScrollDirection.top);
      return [
        showScore(),
        const SizedBox(
          height: 10,
        ),
        fileImage == null
            ? AddGameImageWidget(
                imageReady: _imageReadyHandler,
                withoutImageClickHandler: _noImageHandler,
              )
            : Card(
                margin: const EdgeInsets.all(0.0),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Image.file(fileImage!),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size.fromHeight(40),
                          ),
                          onPressed: () {
                            setState(() {
                              step = 4;
                            });
                          },
                          child: const Text(
                            "Далее",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size.fromHeight(40),
                          ),
                          onPressed: () {
                            setState(() {
                              fileImage = null;
                            });
                          },
                          child: const Text(
                            "Изменить фото",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        const SizedBox(
          height: 50,
        ),
      ];
    }

    if (step == 3) {
      return [
        showScore(),
        const SizedBox(
          height: 10,
        ),
        FinalGameImageCardWidget(
          fileImage: fileImage,
          onSuccess: widget.onSuccess,
          createClickHandler: createGameHandler,
          goBackClickHandler: () {
            setState(() {
              step = 2;
            });
          },
          createGameButtonText: "Указать счëт",
        ),
        const SizedBox(
          height: 50,
        ),
      ];
    }

    return [
      Text("step = $step"),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: const Size.fromHeight(36),
        ),
        onPressed: () {
          setState(() {
            step = step - 1;
          });
        },
        child: const Text(
          "Step - 1",
          style: TextStyle(color: Colors.white),
        ),
      )
    ];
  }

  GameSetScoresModel getGameScoresModel() {
    var setData = gameDataWidgetController.getValue();

    var isWinning = gameDataWidgetController.isWinning();

    var player1 = widget.game.players!.first;
    var player2 = widget.game.players!.last;

    return GameSetScoresModel(
      sets: setData,
      player1: player1,
      player2: player2,
      player1Scores: toGameScores(0, setData),
      player2Scores: toGameScores(1, setData),
      winnerId: isWinning ? player1.id! : player2.id!,
    );
  }

  Widget showScore() {
    var gameScores = getGameScoresModel();
    return Card(
      margin: const EdgeInsets.only(
        top: 0,
        left: 0,
        right: 0,
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GameSetScores(
              model: gameScores,
              onTapped: (p) {},
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size.fromHeight(36),
              ),
              onPressed: () {
                setState(() {
                  step = 0;
                });
              },
              child: const Text(
                "Изменить счёт",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showPlayers() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.55,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PlayerColumnWidget(player: widget.game.players!.first),
            PlayerColumnWidget(player: widget.game.players!.last),
          ],
        ),
      ),
    );
  }

  Future<BaseApiResponse> createGameHandler() async {
    var data = courtData!;

    var gameData = TournamentGameData(
      courtName: data.courtName,
      courtType: data.courtType,
      courtCity: data.selectedCity,
      courtCountry: data.selectedCountry,
      score: gameDataWidgetController.getValue(),
      isWinning: gameDataWidgetController.isWinning(),
      imageFileId: imageFileId,
      gameDate: dateAndTimePickerController.value.dateTime,
      gameScores: getGameScoresModel(),
    );

    return widget.createGameClick(gameData);
  }

  PlayerSetScores toGameScores(
      int numberPlayer, List<TennisSetData> scoreData) {
    return GameDataWidgetExtensions.getStringValueGames(
        scoreData, numberPlayer);
  }

  void scrollMove(ScrollDirection scroll) {
    switch (scroll) {
      case ScrollDirection.top:
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        break;
      case ScrollDirection.bottom:
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        break;
    }
  }

  void _imageReadyHandler(int fileId, File file) {
    imageFileId = fileId;

    setState(() {
      fileImage = file;
      step = 3;
    });
  }

  void _noImageHandler() {
    setState(() {
      step = 3;
    });
  }

  void _gameFormCourtDataWidgetHandler(GameFormCourtData data) {
    courtData = data;

    _setStepHandler(2);
  }

  void _saveScore() {
    if (!gameDataWidgetController.isValidMatchData(_errorHandler)) {
      return;
    }
    setState(() {
      step = 1;
    });
  }

  void _errorHandler(String error) {
    BaseApiResponseUtils.showError(context, error);
  }

  void _setStepHandler(int stepParam) {
    setState(() {
      step = stepParam;
    });
    MyApp.inProccess = false;
  }
}
