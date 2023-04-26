class MainSettings {
  static const String domain = "https://play-tennis.online";

  static const String appName = "Play Tennis";

  static const String imageLogoPath = "assets/icons/icon.png";

  static const String loadingGif = "assets/icons/animationLoader.gif";

  static const String loadingPath = "assets/icons/icon.png";

  static const String imageRocket = "assets/icons/icon.png";

  static const String dimaserdPlayerId = "843ea23a-466c-4196-bc1b-01195dabaa9c";

  static const bool showSiteUrls = false;

  static const String privacyPolicy =
      "https://play-tennis.online/docs/politics.html";

  static const String agreement =
      "https://play-tennis.online/docs/agreement.html";

  static String dimaSerdTelegramUrl =
      TelegramRoutesProvider.resolve("dimaserd");
}

class ServerImages {
  static const String defaultAvatarPath =
      "${MainSettings.domain}/images/avatars/default.png";
  static const String logoPath = "${MainSettings.domain}/images/logos/logo.png";
}

class TelegramRoutesProvider {
  static String resolve(String domain) {
    return "tg://resolve?domain=@$domain";
  }
}

class TelegramBotSettings {
  static String link = TelegramRoutesProvider.resolve("tennis_play_bot");

  static const String profileLinkCommandFormat = "/link id some-new-id";
}
