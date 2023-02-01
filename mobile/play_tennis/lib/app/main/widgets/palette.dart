import 'package:flutter/material.dart';

//http://hex2rgba.devoth.com/ hex to rgba

Color mainColor = const Color.fromRGBO(48, 51, 54, 1);

Map<int, Color> godografColorMap = {
  50: const Color.fromRGBO(48, 51, 54, .1),
  100: const Color.fromRGBO(48, 51, 54, .2),
  200: const Color.fromRGBO(48, 51, 54, .3),
  300: const Color.fromRGBO(48, 51, 54, .4),
  400: const Color.fromRGBO(48, 51, 54, .5),
  500: const Color.fromRGBO(48, 51, 54, .6),
  600: const Color.fromRGBO(48, 51, 54, .7),
  700: const Color.fromRGBO(48, 51, 54, .8),
  800: const Color.fromRGBO(48, 51, 54, .9),
  900: const Color.fromRGBO(48, 51, 54, 1),
};
MaterialColor godografMaterialColor =
    MaterialColor(0xFF303336, godografColorMap);

MaterialColor mainMaterialColor = godografMaterialColor;
