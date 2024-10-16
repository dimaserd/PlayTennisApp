import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/Inputs/TextInput.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/main-services.dart';

class PlayerConfirmationWidget extends StatefulWidget {
  final PlayerData player;

  const PlayerConfirmationWidget({super.key, required this.player});

  @override
  State<PlayerConfirmationWidget> createState() =>
      _PlayerConfirmationWidgetState();
}

class _PlayerConfirmationWidgetState extends State<PlayerConfirmationWidget> {
  TextEditingController codeConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var text = "Ваша учётная запись не подтверждена!";

    if (!widget.player.emailConfirmed) {
      text += " Подтвердите адрес электронной почты.";
    } else if (!widget.player.accountConfirmed) {
      text +=
          " В ближайшее время с вами свяжется админстратор портала. Мы вам позвоним на ${widget.player.phoneNumber}. Вы можете подтвердить свою учётную запись самостоятельно, привязав ваш Telegram.";
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.redAccent,
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailConfirmationWidget extends StatefulWidget {
  final PlayerData player;

  const EmailConfirmationWidget({super.key, required this.player});

  @override
  State<EmailConfirmationWidget> createState() =>
      _EmailConfirmationWidgetState();
}

class _EmailConfirmationWidgetState extends State<EmailConfirmationWidget> {
  TextEditingController codeConfirmationController = TextEditingController();
  bool isConfirming = false;

  @override
  Widget build(BuildContext context) {
    return widget.player.emailConfirmed
        ? const SizedBox.shrink()
        : SizedBox(
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        "На указанный вами электронный адрес ${widget.player.email} отправлен код потдверждения. Введите его здесь и нажмите кнопку \"Подтвердить\""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextInput(
                      labelText: "Код потверждения",
                      textController: codeConfirmationController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(30), // NEW
                      ),
                      onPressed: confirmEmail,
                      child: const Text(
                        "Подтвердить",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  confirmEmail() {
    if (isConfirming) {
      return;
    }

    isConfirming = true;

    AppServices.playerService
        .confirmEmail(codeConfirmationController.text)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value.message),
        backgroundColor:
            value.isSucceeded ? Colors.greenAccent : Colors.redAccent,
      ));

      if (value.isSucceeded) {
        setState(() {
          widget.player.emailConfirmed = true;
        });
      }
      isConfirming = false;
    });
  }
}
