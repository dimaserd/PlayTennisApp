import 'package:play_tennis/logic/ptc/services/CourtCardService.dart';
import 'logic/clt/services/ClientService.dart';
import 'logic/clt/services/LoginService.dart';
import 'logic/clt/services/RegistrationService.dart';
import 'logic/core/NetworkService.dart';
import 'logic/files/services/FilesService.dart';
import 'logic/ptc/services/CityService.dart';
import 'logic/ptc/services/CountryService.dart';
import 'logic/ptc/services/FlutterNotificationAppTokenService.dart';
import 'logic/ptc/services/GameRequestsService.dart';
import 'logic/ptc/services/GameService.dart';
import 'logic/ptc/services/PlayerLoginLinkService.dart';
import 'logic/ptc/services/PlayerRegistrationService.dart';
import 'logic/ptc/services/PlayerService.dart';
import 'logic/ptc/services/CommunityCardService.dart';
import 'logic/ptc/services/TrainerCardService.dart';
import 'main-settings.dart';

class AppServices {
  static final NetworkService networkService =
      NetworkService(MainSettings.domain);

  static final GameService gameService = GameService(networkService);
  static final LoginService loginService = LoginService(networkService);
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
  static final PlayerLoginLinkService playerLoginLinkService =
      PlayerLoginLinkService(networkService);
  static final CityService cityService = CityService(networkService);
  static final CommunityCardService communityService =
      CommunityCardService(networkService);
  static final TrainerCardService trainerCardService =
      TrainerCardService(networkService);
  static final CourtCardService courtCardService =
      CourtCardService(networkService);
}
