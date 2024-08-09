import 'package:flutter/material.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAlertContact extends StatelessWidget {
  final String title;
  final String subTitle;

  const ShowAlertContact(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          showAlert(context);
        },
        child: Center(child: Text(title)),
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  subTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Дмитрий Сердюков:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
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
                        Uri.parse(MainSettings.dimaSerdTelegramUrl());
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
                child: const Center(
                    child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
