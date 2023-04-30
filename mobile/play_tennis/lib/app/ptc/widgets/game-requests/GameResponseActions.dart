import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/ResponseForGameRequestIdModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'package:play_tennis/logic/ptc/services/GameRequestsService.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main.dart';
import 'package:url_launcher/url_launcher.dart';

class GameResponseActions extends StatelessWidget {
  const GameResponseActions({
    Key? key,
    required this.request,
    required this.response,
    required this.loginData,
  }) : super(key: key);

  final GameRequestDetailedModel request;
  final GameRequestResponseSimpleModel response;
  final CurrentLoginData loginData;

  List<Widget> getButtons(BuildContext context) {
    if (request.author == null || request.author!.id != loginData.userId) {
      return [];
    }

    if (response.acceptedByRequestAuthor) {
      return [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size.fromHeight(36),
            ),
            onPressed: () => _contactsHandler(context),
            child: const Text("Запросить контакты"),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ];
    }

    return [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () => _acceptHandler(context),
          child: const Text("Принять"),
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
          onPressed: () => _declineHandler(context),
          child: const Text("Отказать"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: getButtons(context),
        ),
      ),
    );
  }

  _contactsHandler(BuildContext context) async {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;
    var response = await AppServices.gameRequestsService
        .requestContactData(request.id!, (p) => {});

    if (context.mounted) {
      BaseApiResponseUtils.handleResponse(
        context,
        BaseApiResponse(
          isSucceeded: response.isSucceeded,
          message: response.message,
        ),
      );
      if (response.responseObject != null) {
        _showData(context, response.responseObject!);
      }
    }

    MyApp.inProccess = false;
  }

  _acceptHandler(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;
    var model = ResponseForGameRequestIdModel(
      gameRequestId: request.id!,
      playerId: response.author!.id!,
    );
    AppServices.gameRequestsService.acceptResponse(model, (e) {}).then(
      (resp) {
        MyApp.inProccess = false;
        if (context.mounted) {
          BaseApiResponseUtils.handleResponse(context, resp);
        }
      },
    );
  }

  _declineHandler(BuildContext context) {
    if (MyApp.inProccess) {
      return;
    }

    MyApp.inProccess = true;
    var model = ResponseForGameRequestIdModel(
      gameRequestId: request.id!,
      playerId: response.author!.id!,
    );
    AppServices.gameRequestsService.declineResponse(model, (e) {}).then(
      (resp) {
        MyApp.inProccess = false;
        if (context.mounted) {
          BaseApiResponseUtils.handleResponse(context, resp);
        }
      },
    );
  }

  _showData(BuildContext context, PlayerContactData contactData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Контактные данные"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "SomeTitle",
                ),
                const SizedBox(height: 16),
                const Text(
                  'Дмитрий Сердюков:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  child: const Text(
                    'Телеграмм: @dimaserd',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    var telegramUser =
                        Uri.parse("tg://resolve?domain=@dimaserd");
                    launchUrl(telegramUser);
                  },
                ),
                const SizedBox(height: 8),
                InkWell(
                  child: const Text(
                    'Телефон: +7 916 604-49-60',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    var phoneNumber = Uri.parse("tel://+79166044960");
                    launchUrl(phoneNumber);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Center(child: Text('OK')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
