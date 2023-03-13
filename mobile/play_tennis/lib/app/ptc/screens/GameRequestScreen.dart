import 'dart:async';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/ShowGameRequestData.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/SearchGameRequestResponses.dart';
import 'package:play_tennis/main-services.dart';

class GameRequestScreen extends StatefulWidget {
  final String id;
  const GameRequestScreen({super.key, required this.id});

  @override
  State<GameRequestScreen> createState() => _GameRequestScreenState();
}

class _GameRequestScreenState extends State<GameRequestScreen> {
  late CurrentLoginData loginData;
  late GameRequestDetailedModel? request;
  late List<GameRequestResponseSimpleModel> responses = [];
  late bool loaded = false;
  late bool loginDataLoaded = false;
  Timer? timer;

  @override
  void initState() {
    loadWidgetData();
    super.initState();

    timer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) => loadRequest());
  }

  loadWidgetData() {
    AppServices.loginService.getLoginData().then((value) {
      loginData = value;
      loginDataLoaded = true;
    });
  }

  loadRequest() {
    if (!loginDataLoaded) {
      return;
    }
    AppServices.gameRequestsService.getById(widget.id).then((value) {
      request = value;
      loadResponses();
    });
  }

  loadResponses() {
    var model = SearchGameRequestResponses(
      q: null,
      gameRequestId: widget.id,
      count: 10,
      offSet: 0,
    );
    AppServices.gameRequestsService.searchResponses(model).then((value) {
      responses = value.list;
      if (!mounted) {
        return;
      }
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: loaded && request != null
            ? ShowGameRequestData(
                request: request!,
                responses: responses,
                loginData: loginData,
                onChange: () {
                  Navigator.of(context).pop();
                },
              )
            : const Loading(text: "Заявка на игру загружается"),
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(getTitleText()),
        ),
      ),
    );
  }

  String getTitleText() {
    if (loaded) {
      if (request!.author!.id == loginData.userId) {
        return "Ваша заявка на игру";
      }
      return "Заявка на игру";
    }

    return "Загрузка заявки...";
  }
}
