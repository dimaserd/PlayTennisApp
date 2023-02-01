import 'package:flutter/material.dart';
import '../../../../logic/clt/models/CurrentLoginData.dart';
import '../../../../logic/ptc/models/game-requests/GameRequestResponseSimpleModel.dart';
import 'GameResponseToSelect.dart';

class GameRequestResponsesList extends StatelessWidget {
  final List<GameRequestResponseSimpleModel> responses;
  final CurrentLoginData loginData;
  final String requestId;

  GameRequestResponsesList({
    required this.requestId,
    required this.responses,
    required this.loginData,
  });

  @override
  Widget build(BuildContext context) {
    var text = responses.isEmpty
        ? "На вашу заявку пока никто не откликнулся."
        : "Отклики:";

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        responses.isNotEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                width: double.infinity,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
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
        SizedBox(
            height: 300,
            child: responses.isEmpty
                ? const SizedBox.shrink()
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return GameResponseToSelect(
                        requestId: requestId,
                        response: responses[index],
                        loginData: loginData,
                        onChanged: () {},
                      );
                    },
                    itemCount: responses.length,
                  )),
      ],
    );
  }
}
