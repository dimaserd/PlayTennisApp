import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAlertAddTrainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      const Text('Спасибо, что вы здесь! Сообщение для вас!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Для добавления тренера необходимо связаться с Дмитрием.',
                      ),
                      const SizedBox(height: 16),
                      const Text('Свяжитесь с нами:'),
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
        },
        child: const Center(child: Text('Добавить тренера')),
      ),
    );
  }
}
