import 'package:play_tennis/main-state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main-services.dart';
import 'main-settings.dart';

class MainAppExtensions {
  static Future<void> trylaunchAppUrl(
    String appRelativeUrl,
    Function(String) onError,
  ) async {
    if (!MainState.isAuthorized) {
      await launchUrlInBrowser(MainSettings.domain, onError);
      return;
    }
    final result =
        await AppServices.playerLoginLinkService.createLoginLink((p0) => {});

    if (!result.isSucceeded) {
      onError(result.errorMessage ?? "Ошибка при авторизации по кнопке");
      return;
    }

    var dottedUrl = appRelativeUrl.replaceAll(RegExp(r'/'), '.');

    var url =
        "${MainSettings.domain}/ptc/player-login/${result.loginId!}/${result.password!}/$dottedUrl";

    await launchUrlInBrowser(url, onError);
  }

  static Future<void> launchUrlInBrowser(
    String url,
    Function(String) onError,
  ) async {
    var uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
