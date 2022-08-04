import 'package:flutter/material.dart';

class DateHelper {
  static DateHelper? _instance;

  DateHelper._();

  factory DateHelper() {
    return _instance!;
  }

  static DateHelper? getInstance() {
    _instance ??= DateHelper._();
    return _instance;
  }

  String getTimeName({String? userLocale}) {
    DateTime now = DateTime.now();
    debugPrint(now.toString());
    if ((now.hour >= 0 && now.hour < 6) || (now.hour >= 19 && now.hour <= 23 )) {
      return "Night";
    } else if (now.hour >= 6 && now.hour < 12) {
      return "Morning";
    } else if (now.hour >= 12 && now.hour < 17) {
      return "Afternoon";
    } else if (now.hour >= 17 && now.hour < 19) {
      return "Evening";
    }
    return "";
  }
}
