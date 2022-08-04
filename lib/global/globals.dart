import 'package:flutter/material.dart';

class Globals {
  static String currentVersion = "1.0.3";
  static List<String> supportLocales = ['en', 'zh'];
  static Map<String, String> mapSupportLocales = {
    'en': "English",
    'zh': "繁體中文",
  };
  static const textOrganeColor = Colors.orange;
  static Color? navigationBarTextColor = Colors.grey[600];
  static const backgroundColor = Colors.grey;
  static const greyTextColor = Color(0xFFE0DDDE);
  static const errorTextColor = Colors.red;
  static const tagBackgroundColor = Color.fromRGBO(13, 74, 229, 0.62);
  static const socketIOUrl = "ws://localhost:3000/";
}
