import 'package:flutter/material.dart';
import 'package:play_tennis/logic/clt/services/NotificationService.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onTapHandler(trainers[index]);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          color: Colors.blueAccent,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  notification.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  notification.text!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const NotificationCardActions(),
              ],
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCardActions extends StatelessWidget {
  const NotificationCardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [],
    );
  }
}
