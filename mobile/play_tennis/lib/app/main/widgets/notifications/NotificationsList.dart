import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/notifications/NotificationCard.dart';
import 'package:play_tennis/logic/clt/services/NotificationService.dart';

class NotificationsList extends StatelessWidget {
  List<NotificationModel> notifications;
  final void Function(NotificationModel trainer) onTapHandler;
  final void Function(int offSet) getData;

  int offset;
  bool isActiveLoader = true;

  NotificationsList({
    super.key,
    required this.isActiveLoader,
    required this.offset,
    required this.onTapHandler,
    required this.notifications,
    required this.getData,
  }) {
    addScrollListener();
  }

  final ScrollController _scrollController = ScrollController();

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offset += 10;
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() {
    getData(offset);
  }

  Widget getChild() {
    return notifications.isEmpty
        ? Column(children: const [
            Center(
              child: Text(
                "У вас нет уведомлений",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ])
        : ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index == notifications.length) {
                if (isActiveLoader == false || notifications.length < 5) {
                  return const SizedBox(
                    height: 20,
                  );
                } else {
                  // Вернуть заглушку для отображения индикатора загрузки
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return NotificationCard(
                  notification: notifications[index],
                );
              }
            },
            itemCount: notifications.length + 1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return getChild();
  }
}
