import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApplicationScreen extends StatelessWidget {
  const AboutApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Для добавления тренера пожалуйста напишите мне.',
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
            var telegramUser = Uri.parse("tg://resolve?domain=@dimaserd");
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
    );
  }
}
