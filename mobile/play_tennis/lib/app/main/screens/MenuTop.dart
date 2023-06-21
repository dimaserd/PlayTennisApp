import 'package:flutter/material.dart';

class MenuTop extends StatelessWidget {
  const MenuTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Text("Сетка",
                        style: TextStyle(
                            color: Color(0xFF333A3B),
                            fontFamily: "OpenSans-Bold",
                            fontSize: 45)),
                    Text("пятница, 5 мая",
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 18,
                            color: Color(0xFF5A6569)))
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/bell.png",
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 5),
                    Image.asset(
                      "assets/icons/icon.png",
                      height: 50,
                      width: 50,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'Поиск корта и игрока',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0)),
            ),
          ]),
        ),
      ),
    );
  }
}
