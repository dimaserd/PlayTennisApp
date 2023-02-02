import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/logic/files/services/FilesService.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'logic/clt/services/ClientService.dart';
import 'logic/clt/services/RegistrationService.dart';
import 'logic/clt/services/LoginService.dart';
import 'logic/core/NetworkService.dart';
import 'logic/ptc/services/CountryService.dart';
import 'logic/ptc/services/GameRequestsService.dart';
import 'logic/ptc/services/PlayerRegistrationService.dart';
import 'logic/ptc/services/PlayerService.dart';
import 'main-routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main-settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool inProccess = false;
  static final NetworkService networkService = NetworkService(MainSettings.domain);
  static final LoginService loginService = LoginService(networkService);
  static final RegistrationService registrationService = RegistrationService(networkService);
  static final ClientService clientService = ClientService(networkService);
  static final PlayerRegistrationService playerRegistrationService =
      PlayerRegistrationService(networkService);
  static final FilesService filesService = FilesService(networkService);
  static final CountryService countryService = CountryService(networkService);
  static final GameRequestsService gameRequestsService = GameRequestsService(networkService);

  static final PlayerService playerService = PlayerService(networkService);
  static final GameService gameService = GameService(networkService);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: MainSettings.appName,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        theme: ThemeData(
          bottomAppBarColor: mainMaterialColor,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: mainMaterialColor)
              .copyWith(secondary: Colors.amber),
        ),
        onGenerateRoute: (settings) => MainRoutes.onGenerateRoute(settings),
      ),
    );
  }
}
