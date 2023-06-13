import 'package:play_tennis/logic/clt/services/ClientService.dart';
import 'package:play_tennis/logic/clt/services/LoginLinkService.dart';
import 'package:play_tennis/logic/clt/services/LoginService.dart';
import 'package:play_tennis/logic/clt/services/NotificationService.dart';
import 'package:play_tennis/logic/clt/services/RegistrationService.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/files/services/FilesService.dart';
import 'package:play_tennis/logic/ptc/services/CityService.dart';
import 'package:play_tennis/logic/ptc/services/CommunityCardService.dart';
import 'package:play_tennis/logic/ptc/services/CountryService.dart';
import 'package:play_tennis/logic/ptc/services/CourtCardService.dart';
import 'package:play_tennis/logic/ptc/services/DeletePlayerService.dart';
import 'package:play_tennis/logic/ptc/services/FlutterNotificationAppTokenService.dart';
import 'package:play_tennis/logic/ptc/services/GameRequestsService.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';
import 'package:play_tennis/logic/ptc/services/PlayerRegistrationService.dart';
import 'package:play_tennis/logic/ptc/services/PlayerService.dart';
import 'package:play_tennis/logic/ptc/services/TelegramPlayerService.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import 'main-settings.dart';

class AppServices {
  static final NetworkService networkService =
      NetworkService(MainSettings.domain);

  static final GameService gameService = GameService(networkService);
  static final LoginService loginService = LoginService(networkService);
  static final NotificationService notificationService =
      NotificationService(networkService);
  static final FlutterNotificationAppTokenService appNotificationTokenService =
      FlutterNotificationAppTokenService(networkService);
  static final ClientService clientService = ClientService(networkService);
  static final CountryService countryService = CountryService(networkService);
  static final RegistrationService registrationService =
      RegistrationService(networkService);
  static final GameRequestsService gameRequestsService =
      GameRequestsService(networkService);

  static final PlayerService playerService = PlayerService(networkService);
  static final FilesService filesService = FilesService(networkService);
  static final PlayerRegistrationService playerRegistrationService =
      PlayerRegistrationService(networkService);
  static final LoginLinkService playerLoginLinkService =
      LoginLinkService(networkService);
  static final CityService cityService = CityService(networkService);
  static final CommunityCardService communityService =
      CommunityCardService(networkService);
  static final TrainerCardService trainerCardService =
      TrainerCardService(networkService);
  static final CourtCardService courtCardService =
      CourtCardService(networkService);
  static final TournamentService tournamentService =
      TournamentService(networkService);
  static final DeletePlayerService deletePlayerService =
      DeletePlayerService(networkService);
  static final TelegramPlayerService telegramPlayerService =
      TelegramPlayerService(networkService);
}
