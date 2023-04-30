import 'package:play_tennis/main-routes.dart';

class WebAppRouteMatchResult {
  final bool succeeded;
  final String appRoute;
  final String webRoute;

  WebAppRouteMatchResult({
    required this.succeeded,
    required this.appRoute,
    required this.webRoute,
  });
}

class WebAppRoutes {
  static WebAppRouteMatchResult match(String webRoute) {
    if (webRoute.contains("/ptc/player/")) {
      var playerId = webRoute.replaceAll("/ptc/player/", "");

      return WebAppRouteMatchResult(
          succeeded: true,
          appRoute: MainRoutes.toPlayerCardRoute(playerId),
          webRoute: webRoute);
    }

    return WebAppRouteMatchResult(
      succeeded: false,
      appRoute: "",
      webRoute: webRoute,
    );
  }
}
