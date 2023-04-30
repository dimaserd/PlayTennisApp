import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/screens/ChangeAvatarScreen.dart';
import 'package:play_tennis/app/main/screens/CheckAuthScreen.dart';
import 'package:play_tennis/app/main/screens/LoginScreen.dart';
import 'package:play_tennis/app/main/screens/NotificationsScreen.dart';
import 'package:play_tennis/app/main/screens/ProfileScreen.dart';
import 'package:play_tennis/app/main/screens/RegistrationScreen.dart';
import 'package:play_tennis/app/main/screens/RouteNotFoundScreen.dart';
import 'package:play_tennis/app/main/screens/SetLocationScreenWidget.dart';
import 'package:play_tennis/app/ptc/screens/TelegramProfileScreen.dart';
import 'package:play_tennis/app/main/widgets/images/ImageViewWidget.dart';
import 'package:play_tennis/app/ptc/screens/AboutApplicationScreen.dart';
import 'package:play_tennis/app/ptc/screens/AddGameRequestScreen.dart';
import 'package:play_tennis/app/ptc/screens/ChangePassScreen.dart';
import 'package:play_tennis/app/ptc/screens/CreateGameScreen.dart';
import 'package:play_tennis/app/ptc/screens/EditProfileScreen.dart';
import 'package:play_tennis/app/ptc/screens/GameRequestScreen.dart';
import 'package:play_tennis/app/ptc/screens/MainScreen.dart';
import 'package:play_tennis/app/ptc/screens/PlayScreen.dart';
import 'package:play_tennis/app/ptc/screens/PlayerScreen.dart';
import 'package:play_tennis/app/ptc/screens/TelegramLinkScreen.dart';
import 'package:play_tennis/app/ptc/screens/TournamentsScreen.dart';
import 'package:play_tennis/logic/ptc/models/PlayerModel.dart';

class MainRoutes {
  static String checkAuth = '/';
  static String forgotPass = "/forgotpass";
  static String home = '/home';
  static String login = '/login';
  static String play = "/play";
  static String notifications = "/notificatins";
  static String profile = "/profile";

  static String toPlayerCardRoute(String playerId) {
    return '/player/$playerId';
  }

  static void toPlayerCard(BuildContext context, String playerId) {
    Navigator.of(context).pushNamed(toPlayerCardRoute(playerId));
  }

  static void toGameRequestCard(BuildContext context, String requestId) {
    Navigator.of(context).pushNamed("/game-request/$requestId");
  }

  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name == checkAuth) {
      return MaterialPageRoute(
        builder: (context) => const CheckAuthScreen(),
      );
    }

    if (settings.name == home) {
      return MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
    }

    if (settings.name == '/set-location') {
      return MaterialPageRoute(
        builder: (context) => SetLocationScreenWidget(),
      );
    }

    if (settings.name == '/about') {
      return MaterialPageRoute(
        builder: (context) => const AboutApplicationScreen(),
      );
    }

    if (settings.name == '/players') {
      return MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
    }

    if (settings.name == notifications) {
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    }

    if (settings.name == '/tournaments') {
      return MaterialPageRoute(
        builder: (context) => const TournamentsScreen(),
      );
    }

    if (settings.name == play) {
      return MaterialPageRoute(
        builder: (context) => const PlayScreen(),
      );
    }

    if (settings.name == login) {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    }

    if (settings.name == '/registration') {
      return MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      );
    }

    if (settings.name == forgotPass) {
      return MaterialPageRoute(
        builder: (context) => const ChangePassScreen(),
      );
    }

    if (settings.name == '/change-avatar') {
      return MaterialPageRoute(
          builder: (context) => const ChangeAvatarScreen());
    }

    if (settings.name == profile) {
      return MaterialPageRoute(
        builder: (context) => ProfileScreen(
          key: UniqueKey(),
        ),
      );
    }

    if (settings.name == '/profile/telegram') {
      return MaterialPageRoute(
        builder: (context) => TelegramProfileScreen(
          key: UniqueKey(),
        ),
      );
    }

    if (settings.name == '/profile-telegram-link') {
      return MaterialPageRoute(
        builder: (context) => TelegramLinkScreen(
          key: UniqueKey(),
        ),
      );
    }

    if (settings.name == '/profile-edit') {
      return MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      );
    }

    //Многоуровневые маршруты
    var uri = Uri.parse(settings.name!);

    // Обработка '/subject/:id'
    if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'show-image') {
      var fileId = int.parse(uri.pathSegments[1]);
      return MaterialPageRoute(
        builder: (newContext) => ImageViewWidgetExtensions.getScaffold(
          ImageViewWidgetExtensions.buildOriginalUrl(fileId),
        ),
      );
    }

    // Обработка '/player/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'player') {
      var id = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) => PlayerScreen(id: id),
      );
    }

    if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'game-request') {
      var id = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) => GameRequestScreen(id: id),
      );
    }

    if (settings.name == '/game-requests/add') {
      return MaterialPageRoute(
        builder: (context) => const AddGameRequestScreen(),
      );
    }

    if (settings.name == '/games/add') {
      return MaterialPageRoute(
        builder: (context) => CreateGameScreen(
          player: null,
          key: UniqueKey(),
        ),
      );
    }

    if (settings.name == '/create/game') {
      var playerArguments = settings.arguments as PlayerModel;
      return MaterialPageRoute(
        builder: (context) => CreateGameScreen(
          player: playerArguments,
          key: UniqueKey(),
        ),
      );
    }

    return MaterialPageRoute(
      builder: (context) => RouteNotFoundScreen(settings.name),
    );
  }
}
