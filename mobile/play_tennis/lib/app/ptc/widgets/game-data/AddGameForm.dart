import 'dart:io';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/CustomDateAndTimePickerWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/AddGameImageWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/FinalGameImageCardWidget.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormExtensions.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormMatchInfoWidget.dart';
import 'package:play_tennis/app/ptc/widgets/games/GameDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/courts/CourtTypeSelect.dart';
import 'package:play_tennis/app/ptc/widgets/game-data/GameFormCourtDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/players/SearchPlayersForm.dart';
import 'package:play_tennis/app/ptc/widgets/players/ShowPlayerData.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/ptc/models/LocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerLocationData.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CountrySimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';

class SingleGameData {
  String courtType;
  String courtName;
  PlayerModel opponent;
  List<TennisSetData> score;
  CityModel courtCity;
  CountrySimpleModel courtCountry;
  bool isWinning;
  DateTime gameDate;
  int? imageFileId;

  SingleGameData({
    required this.courtType,
    required this.courtName,
    required this.opponent,
    required this.score,
    required this.courtCity,
    required this.courtCountry,
    required this.isWinning,
    required this.imageFileId,
    required this.gameDate,
  });
}

enum ScrollDirection { top, bottom }

class AddGameForm extends StatefulWidget {
  final Future<BaseApiResponse> Function(SingleGameData) createGameClick;
  final Function() onSuccess;
  final PlayerModel? player;

  const AddGameForm({
    Key? key,
    required this.createGameClick,
    required this.onSuccess,
    required this.player,
  }) : super(key: key);

  @override
  State<AddGameForm> createState() => _AddGameFormState();
}

class _AddGameFormState extends State<AddGameForm> {
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

  PlayerModel? opponent;
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
    if (widget.player != null) {
      setOpponent(widget.player!);
    }
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
          ));
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
      opponent = player;
      setState(() {
        step = 1;
      });
    }
  }

  List<Widget> getStepWidgets() {
    if (step == 0) {
      return [
        const Text(
          "Выберите соперника",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          child: SearchPlayersForm(
            locationData: LocationDataMappingExtensions.toLocationData(
              locationData!,
            ),
            onTapHandler: (p) {
              setOpponent(p);
            },
          ),
        )
      ];
    }

    if (step == 1) {
      return [
        PlayerCard(
          player: opponent!,
          margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
        ),
        const SizedBox(
          height: 5,
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
          child: const Text("Выбрать другого соперника"),
        ),
        const SizedBox(
          height: 5,
        ),
        !hasScore
            ? GestureDetector(
                onVerticalDragDown: (_) {
                  FocusScope.of(context).unfocus();
                },
                child: Card(
                  margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
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
                        child: const Text("Далее"),
                      )
                    ]),
                  ),
                ))
            : const SizedBox.shrink(),
        const SizedBox(
          height: 10,
        ),
        hasScore
            ? Card(
                margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    ...GameFormExtensions.getMatchText(
                      context,
                      opponent!,
                      gameDataWidgetController.isWinning(),
                      gameDataWidgetController.getStringValue(),
                      [],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: () => _setStepHandler(2),
                      child: const Text("Подтвердить"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: () {
                        setState(() {
                          hasScore = false;
                        });
                      },
                      child: const Text("Назад"),
                    ),
                  ]),
                ),
              )
            : const SizedBox.shrink()
      ];
    }

    if (step == 2) {
      return [
        SizedBox(
          width: double.infinity,
          height: 115,
          child: GameFormMatchInfoWidget(
            context: context,
            opponent: opponent!,
            gameDataWidgetController: gameDataWidgetController,
            backBtnHandler: () => _setStepHandler(1),
            courtType: courtTypeSelectController.value,
            showCourtType: false,
            customWidgets: const [],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GameFormCourtDataWidget(
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

    if (step == 3) {
      scrollMove(ScrollDirection.top);
      return [
        FractionallySizedBox(
            widthFactor: 1.0,
            child: SizedBox(
              child: GameFormMatchInfoWidget(
                context: context,
                opponent: opponent!,
                gameDataWidgetController: gameDataWidgetController,
                backBtnHandler: () => _setStepHandler(2),
                courtType: courtTypeSelectController.value,
                showCourtType: true,
                customWidgets: [
                  const SizedBox(
                    height: 10,
                  ),
                  ...getGameDataExtraWidgets()
                ],
              ),
            )),
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
                          child: const Text("Далее"),
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
                          child: const Text("Изменить фото"),
                        ),
                      )
                    ],
                  ),
                ),
              )
      ];
    }

    if (step == 4) {
      return [
        FractionallySizedBox(
            widthFactor: 1.0,
            child: SizedBox(
              child: GameFormMatchInfoWidget(
                context: context,
                opponent: opponent!,
                gameDataWidgetController: gameDataWidgetController,
                backBtnHandler: () => _setStepHandler(3),
                courtType: courtTypeSelectController.value,
                showCourtType: true,
                customWidgets: [
                  const SizedBox(
                    height: 10,
                  ),
                  ...getGameDataExtraWidgets()
                ],
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        FinalGameImageCardWidget(
          fileImage: fileImage,
          onSuccess: widget.onSuccess,
          createClickHandler: createGameHandler,
          goBackClickHandler: () {
            setState(() {
              step = 3;
            });
          },
        ),
      ];
    }

    return [];
  }

  List<Widget> getGameDataExtraWidgets() {
    return [
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
          "Корт: ${courtNameController.text}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Покрытие: ${CourtTypeConsts.texts[courtTypeSelectController.value]}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];
  }

  Future<BaseApiResponse> createGameHandler() async {
    var data = courtData!;

    var gameData = SingleGameData(
      courtName: data.courtName,
      courtType: data.courtType,
      courtCity: data.selectedCity,
      courtCountry: data.selectedCountry,
      opponent: opponent!,
      score: gameDataWidgetController.getValue(),
      isWinning: gameDataWidgetController.isWinning(),
      imageFileId: imageFileId,
      gameDate: dateAndTimePickerController.value.dateTime,
    );

    return widget.createGameClick(gameData);
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
      step = 4;
    });
  }

  void _noImageHandler() {
    setState(() {
      step = 4;
    });
  }

  void _gameFormCourtDataWidgetHandler(GameFormCourtData data) {
    courtData = data;

    if (opponent == null) {
      _errorHandler("Ошибка. Соперник не указан.");
      return;
    }

    _setStepHandler(3);
  }

  void _saveScore() {
    if (!gameDataWidgetController.isValidMatchData(_errorHandler)) {
      return;
    }
    setState(() {
      hasScore = true;
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
