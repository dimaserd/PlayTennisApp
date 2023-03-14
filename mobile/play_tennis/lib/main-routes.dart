import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/screens/ChangeAvatarScreen.dart';
import 'package:play_tennis/app/main/screens/CheckAuthScreen.dart';
import 'package:play_tennis/app/main/screens/LoginScreen.dart';
import 'package:play_tennis/app/main/screens/ProfileScreen.dart';
import 'package:play_tennis/app/main/screens/RegistrationScreen.dart';
import 'package:play_tennis/app/main/screens/RouteNotFoundScreen.dart';
import 'package:play_tennis/app/main/widgets/images/ImageViewWidget.dart';
import 'package:play_tennis/app/ptc/screens/AboutApplicationScreen.dart';
import 'package:play_tennis/app/ptc/screens/AddGameRequestScreen.dart';
import 'package:play_tennis/app/ptc/screens/CreateGameScreen.dart';
import 'package:play_tennis/app/ptc/screens/EditProfileScreen.dart';
import 'package:play_tennis/app/ptc/screens/GameRequestScreen.dart';
import 'package:play_tennis/app/ptc/screens/GamesRequestsScreen.dart';
import 'package:play_tennis/app/ptc/screens/MainScreen.dart';
import 'package:play_tennis/app/ptc/screens/PlayScreen.dart';
import 'package:play_tennis/app/ptc/screens/PlayerScreen.dart';
import 'package:play_tennis/app/ptc/screens/TournamentsScreen.dart';

class MainRoutes {
  static void toPlayerCard(BuildContext context, String playerId) {
    Navigator.of(context).pushNamed('/player/$playerId');
  }

  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => const CheckAuthScreen());
    }

    if (settings.name == '/home') {
      return MaterialPageRoute(builder: (context) => const MainScreen());
    }

    if (settings.name == '/about') {
      return MaterialPageRoute(
        builder: (context) => const AboutApplicationScreen(),
      );
    }

    if (settings.name == '/players') {
      return MaterialPageRoute(builder: (context) => const MainScreen());
    }

    if (settings.name == '/tournaments') {
      return MaterialPageRoute(builder: (context) => const TournamentsScreen());
    }

    if (settings.name == '/play') {
      return MaterialPageRoute(builder: (context) => const PlayScreen());
    }

    if (settings.name == '/game-requests/mine') {
      return MaterialPageRoute(
          builder: (context) => const GamesRequestsScreen(
                showMine: true,
              ));
    }

    if (settings.name == '/login') {
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    }

    if (settings.name == '/registration') {
      return MaterialPageRoute(
          builder: (context) => const RegistrationScreen());
    }

    if (settings.name == '/change-avatar') {
      return MaterialPageRoute(
          builder: (context) => const ChangeAvatarScreen());
    }

    if (settings.name == '/profile') {
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    }

    if (settings.name == '/profile-edit') {
      return MaterialPageRoute(builder: (context) => const EditProfileScreen());
    }

    //Многоуровневые маршруты
    var uri = Uri.parse(settings.name!);

    // Обработка '/subject/:id'
    if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'show-image') {
      var fileId = int.parse(uri.pathSegments[1]);
      print("show-image logic $fileId");
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
          builder: (context) => const AddGameRequestScreen());
    }

    if (settings.name == '/games/add') {
      return MaterialPageRoute(builder: (context) => const CreateGameScreen());
    }

    return MaterialPageRoute(
        builder: (context) => RouteNotFoundScreen(settings.name));
  }
}
