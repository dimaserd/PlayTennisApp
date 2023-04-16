import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/profile/TelegramLinkWidget.dart';
import 'package:play_tennis/main-services.dart';

class TelegramLinkScreen extends StatefulWidget {
  const TelegramLinkScreen({super.key});

  @override
  State<TelegramLinkScreen> createState() => _TelegramLinkScreen();
}

class _TelegramLinkScreen extends State<TelegramLinkScreen>
    with WidgetsBindingObserver {
  late AppLifecycleState _state;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _state = state;
      if (_state == AppLifecycleState.resumed) {
        checkTelegramData();
      }
    });
  }

  void checkTelegramData() async {
    var player =
        await AppServices.telegramPlayerService.getTelegramData((error) {});
    if (player.telegramUserId != null) {
      goToTelegramProfile();
    }
  }

  void goToTelegramProfile() {
    if (mounted) {
      Navigator.pushNamed(context, "/profile/telegram");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Привязать Telegram'),
        ),
        drawer: null,
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: TelegramLinkWidget(),
        ),
      ),
    );
  }
}
