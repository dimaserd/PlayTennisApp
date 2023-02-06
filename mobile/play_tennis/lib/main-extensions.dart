import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'baseApiResponseUtils.dart';
import 'main-settings.dart';
import 'main.dart';

class MainAppExtensions {
  static Future<void> trylaunchAppUrl(
    BuildContext context,
    String appRelativeUrl,
  ) async {
    final result = await MyApp.playerLoginLinkService.createLoginLink((p0) => {});

    if (!result.isSucceeded) {
      print("in MainAppExtensions.trylaunchAppUrl: Ошибка при авторизации по кнопке");

      if (context.mounted) {
        BaseApiResponseUtils.showError(
          context,
          result.errorMessage ?? "Ошибка при авторизации по кнопке",
        );
      }

      return;
    }

    var dottedUrl = appRelativeUrl.replaceAll(RegExp(r'/'), '.');

    var url = Uri.parse(
      "${MainSettings.domain}/ptc/player-login/${result.loginId!}/${result.password!}/$dottedUrl",
    );

    await _launchUrl(url);
  }

  static Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
