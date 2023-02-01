import 'package:flutter/material.dart';
import '../../../main-settings.dart';
import '../../../main.dart';
import 'palette.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    MainSettings.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Image.asset(
                    MainSettings.imageLogoPath,
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
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Профиль'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/profile", (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_tennis),
            title: const Text('Играть'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/play", (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_outlined),
            title: const Text('Мои игры'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/games", (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Мои заявки на игру'),
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/game-requests/mine", (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Выйти'),
            onTap: () {
              MyApp.loginService.logOut().then((value) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/", (r) => false);
              });
            },
          ),
        ],
      ),
    );
  }
}
