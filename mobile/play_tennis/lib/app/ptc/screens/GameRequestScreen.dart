import 'dart:async';
import 'package:flutter/material.dart';
import '../../../logic/clt/models/CurrentLoginData.dart';
import '../../../logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import '../../../logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import '../../../logic/ptc/models/game-requests/SearchGameRequestResponses.dart';
import '../../../main.dart';
import '../../main/widgets/Loading.dart';
import '../widgets/game-requests/ShowGameRequestData.dart';

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
    MyApp.loginService.getLoginData().then((value) {
      loginData = value;
      loginDataLoaded = true;
    });
  }

  loadRequest() {
    if (!loginDataLoaded) {
      return;
    }
    MyApp.gameRequestsService.getById(widget.id).then((value) {
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
    MyApp.gameRequestsService.searchResponses(model).then((value) {
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
    return Scaffold(
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
