import 'package:url_launcher/url_launcher.dart';
import 'main-services.dart';
import 'main-settings.dart';

class MainAppExtensions {
  static Future<void> trylaunchAppUrl(
    String appRelativeUrl,
    Function(String) onError,
  ) async {
    final result =
        await AppServices.playerLoginLinkService.createLoginLink((p0) => {});

    if (!result.isSucceeded) {
      onError(result.errorMessage ?? "Ошибка при авторизации по кнопке");
    }

    var dottedUrl = appRelativeUrl.replaceAll(RegExp(r'/'), '.');

    var url =
        "${MainSettings.domain}/ptc/player-login/${result.loginId!}/${result.password!}/$dottedUrl";

    await launchUrlInBrowser(url);
  }

  static Future<void> launchUrlInBrowser(String url) async {
    var uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
