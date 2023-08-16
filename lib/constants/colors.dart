import 'package:flutter/material.dart';

Color primaryColor = Color(0xff040307); //const Color(0xFF3A6344);
Color secondaryColor =
    Color.fromARGB(255, 117, 117, 117); //const Color(0xFFF1EDEF);
Color white = const Color(0xFFFFFFFF);
Color black = const Color(0xFF291E0B);
Color disabledColor = black.withOpacity(.3);

Map<String, Color> priorityColorMap = {
  'high': const Color.fromARGB(255, 215, 71, 66),
  'medium': const Color.fromARGB(255, 245, 191, 30),
  'low': const Color.fromARGB(255, 60, 153, 83)
};

Map<String, Color> priorityColorMapByCode = {
  'L1': const Color.fromARGB(255, 215, 71, 66),
  'L2': Color.fromARGB(255, 237, 183, 22),
  'L3': const Color.fromARGB(255, 60, 153, 83)
};
