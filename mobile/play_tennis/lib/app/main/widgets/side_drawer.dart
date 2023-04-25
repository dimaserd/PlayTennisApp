import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/main-routes.dart';
import 'package:play_tennis/main-services.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:play_tennis/main-state.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: mainColor),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    MainSettings.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                  ),
                  Image.asset(
                    MainSettings.imageRocket,
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/players", (r) => false);
            },
          ),
          MainState.isAuthorized
              ? ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Профиль'),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/profile", (r) => false);
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Логин'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainRoutes.login, (r) => false);
                  },
                ),
          ListTile(
            leading: const Icon(Icons.sports_tennis),
            title: const Text('Играть'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(MainRoutes.play, (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Турниры'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/tournaments", (r) => false);
            },
          ),
          MainState.isAuthorized
              ? ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Уведомления'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/notifications", (r) => false);
                  },
                )
              : const SizedBox.shrink(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('О приложении'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/about", (r) => false);
            },
          ),
          MainState.isAuthorized
              ? ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Выйти'),
                  onTap: () {
                    AppServices.loginService.logOut().then((value) {
                      MainState.isAuthorized = false;
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (r) => false);
                    });
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
