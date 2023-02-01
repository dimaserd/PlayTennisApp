import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';

class RouteNotFoundScreen extends StatelessWidget {
  final String? url;
  const RouteNotFoundScreen(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child:
                Text("Ошибка в приложении. Маршрут не найден. Маршрут = $url"),
          ),
        ),
      ),
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text("Ошибка"),
      ),
    );
  }
}
