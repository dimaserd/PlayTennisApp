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
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          elevation: 4,
          child: ListTile(
            title: Text(
              "${notification.title!} ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(notification.text!),
              ],
              // ),
            ),
          )),
    );
  }
}
