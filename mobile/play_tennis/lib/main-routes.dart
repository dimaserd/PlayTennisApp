import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/screens/ChangeAvatarScreen.dart';
import 'package:play_tennis/app/ptc/screens/AddGameRequestScreen.dart';
import 'package:play_tennis/app/ptc/screens/CreateGameScreen.dart';
import 'package:play_tennis/app/ptc/screens/MyGamesScreen.dart';
import 'package:play_tennis/app/ptc/screens/TrainersPage.dart';
import 'app/main/screens/CheckAuthScreen.dart';
import 'app/main/screens/LoginScreen.dart';
import 'app/main/screens/ProfileScreen.dart';
import 'app/main/screens/RegistrationScreen.dart';
import 'app/main/screens/RouteNotFoundScreen.dart';
import 'app/main/widgets/images/ImageViewWidget.dart';
import 'app/ptc/screens/EditProfileScreen.dart';
import 'app/ptc/screens/GameRequestScreen.dart';
import 'app/ptc/screens/GamesRequestsScreen.dart';
import 'app/ptc/screens/PlayerScreen.dart';
import 'app/ptc/screens/PlayersScreen.dart';

class MainRoutes {
  static MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => const CheckAuthScreen());
    }

    if (settings.name == '/home') {
      return MaterialPageRoute(builder: (context) => const PlayersScreen());
    }

    if (settings.name == '/players') {
      return MaterialPageRoute(builder: (context) => const PlayersScreen());
    }

    if (settings.name == '/play') {
      return MaterialPageRoute(
          builder: (context) => const GamesRequestsScreen(
                showMine: false,
              ));
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
      return MaterialPageRoute(builder: (context) => const RegistrationScreen());
    }

    if (settings.name == '/change-avatar') {
      return MaterialPageRoute(builder: (context) => const ChangeAvatarScreen());
    }

    if (settings.name == '/profile') {
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    }

    if (settings.name == '/profile-edit') {
      return MaterialPageRoute(builder: (context) => const EditProfileScreen());
    }

    if (settings.name == '/games') {
      return MaterialPageRoute(builder: (context) => const MyGamesScreen());
    }

    if (settings.name == '/trainers') {
      return MaterialPageRoute(builder: (context) => const TrainersPage());
    }

    //Многоуровневые маршруты
    var uri = Uri.parse(settings.name!);

    // Обработка '/subject/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'show-image') {
      var fileId = int.parse(uri.pathSegments[1]);
      print("show-image logic $fileId");
      return MaterialPageRoute(
        builder: (newContext) => ImageViewWidgetExtensions.getScaffold(
          ImageViewWidgetExtensions.buildOriginalUrl(fileId),
        ),
      );
    }

    // Обработка '/subject/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'player') {
      var id = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) => PlayerScreen(id: id),
      );
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'game-request') {
      var id = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) => GameRequestScreen(id: id),
      );
    }

    if (settings.name == '/game-requests/add') {
      return MaterialPageRoute(builder: (context) => const AddGameRequestScreen());
    }

    if (settings.name == '/games/add') {
      return MaterialPageRoute(builder: (context) => const CreateGameScreen());
    }

    return MaterialPageRoute(builder: (context) => RouteNotFoundScreen(settings.name));
  }
}
