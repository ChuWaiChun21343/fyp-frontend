import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'package:intl/intl.dart';

class UserInfo {
  static const String _isLogin = 'is_login';
  static const String _isSavedToken = 'is_saved_token';
  static const String _userID = 'user_id';
  static const String _firstTime = 'is_first_time';
  static const String _showMarketPromotion = 'show_market_promotion';
  static const String _marketPromotion = 'market_promotion';
  static const String _userLocale = 'user_locale';
  static const String _userReadNotification = 'notification';
  static const String _unreadNotificationCount = 'unread_count';

  static Future<bool> getLoginStatus() async {
    var isLoginStatus;
    SharedPreferences sp = await SharedPreferences.getInstance();
    isLoginStatus = sp.getBool(_isLogin) ?? false;
    return isLoginStatus;
  }

  static void setLoginStatus(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_isLogin, b);
  }

  static Future<bool> getSavedToken() async {
    var isSavedToken;
    SharedPreferences sp = await SharedPreferences.getInstance();
    isSavedToken = sp.getBool(_isSavedToken) ?? false;
    return isSavedToken;
  }

  static void setSavedToken(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_isSavedToken, b);
  }

  static Future<int> getUserID() async {
    var userID = 0;
    SharedPreferences sp = await SharedPreferences.getInstance();
    userID = sp.getInt(_userID) ?? -1;
    return userID;
  }

  static void setUserID(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(_userID, id);
  }

  static Future<bool> getFirstTimeUseApp() async {
    var isFirstTimeStatus;
    SharedPreferences sp = await SharedPreferences.getInstance();
    isFirstTimeStatus = sp.getBool(_firstTime) ?? true;
    return isFirstTimeStatus;
  }

  static void setFirstTimeUseApp(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_firstTime, b);
  }

  static Future<bool> getShowMarketPromotion() async {
    var showMarketPromotionStatus;
    SharedPreferences sp = await SharedPreferences.getInstance();
    showMarketPromotionStatus = sp.getBool(_showMarketPromotion) ?? true;
    return showMarketPromotionStatus;
  }

  static void setShowMarketPromotion(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_showMarketPromotion, b);
  }

  static Future<bool> getMarketPromotion() async {
    var marketPromotionStatus;
    SharedPreferences sp = await SharedPreferences.getInstance();
    marketPromotionStatus = sp.getBool(_marketPromotion) ?? true;
    return marketPromotionStatus;
  }

  static void setMarketPromotion(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(_marketPromotion, b);
  }

  static Future<String> getUserLocale() async {
    var locale;
    SharedPreferences sp = await SharedPreferences.getInstance();
    locale = sp.getString(_userLocale) ?? "";
    return locale;
  }

  static void setUserLocale(String locale) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_userLocale, locale);
  }
}
