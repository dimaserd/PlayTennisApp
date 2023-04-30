import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/game-requests/GameResponseToSelect.dart';
import 'package:play_tennis/logic/clt/models/CurrentLoginData.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';

class GameRequestResponsesList extends StatelessWidget {
  final List<GameRequestResponseSimpleModel> responses;
  final CurrentLoginData loginData;
  final GameRequestDetailedModel request;

  const GameRequestResponsesList({
    super.key,
    required this.request,
    required this.responses,
    required this.loginData,
  });

  @override
  Widget build(BuildContext context) {
    var text = responses.isEmpty
        ? "На вашу заявку пока никто не откликнулся."
        : "Отклики:";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 5,
        ),
        responses.isNotEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 5,
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Flexible(
          child: responses.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return GameResponseToSelect(
                      request: request,
                      response: responses[index],
                      loginData: loginData,
                      onChanged: () {},
                    );
                  },
                  itemCount: responses.length,
                ),
        ),
      ],
    );
  }
}
