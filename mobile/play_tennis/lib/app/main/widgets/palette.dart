import 'package:flutter/material.dart';

//http://hex2rgba.devoth.com/ hex to rgba

const Color mainColor = Color.fromRGBO(48, 51, 54, 1);

const Map<int, Color> godografColorMap = {
  50: Color.fromRGBO(48, 51, 54, .1),
  100: Color.fromRGBO(48, 51, 54, .2),
  200: Color.fromRGBO(48, 51, 54, .3),
  300: Color.fromRGBO(48, 51, 54, .4),
  400: Color.fromRGBO(48, 51, 54, .5),
  500: Color.fromRGBO(48, 51, 54, .6),
  600: Color.fromRGBO(48, 51, 54, .7),
  700: Color.fromRGBO(48, 51, 54, .8),
  800: Color.fromRGBO(48, 51, 54, .9),
  900: Color.fromRGBO(48, 51, 54, 1),
};

const MaterialColor godografMaterialColor = MaterialColor(0xFF303336, godografColorMap);
const MaterialColor mainMaterialColor = godografMaterialColor;
