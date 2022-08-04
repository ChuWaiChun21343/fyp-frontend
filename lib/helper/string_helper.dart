import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class StringHelper {
  static StringHelper? _instance;

  StringHelper._();

  factory StringHelper() {
    return _instance!;
  }

  static StringHelper? getInstance() {
    _instance ??= StringHelper._();
    return _instance;
  }

  //https://stackoverflow.com/questions/59444837/flutter-dart-regex-to-extract-urls-from-a-string
  List<URLModel> getHttpsWords(String content) {
    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(content);
    List<URLModel> urls = urlMatches.map((urlMatch) {
      String url = content.substring(urlMatch.start, urlMatch.end);
      return URLModel(url: url, startPos: urlMatch.start, endPos: urlMatch.end);
    }).toList();
    return urls;
  }

  String getLink(String url) {
    // final urlRegExp = RegExp(
    //     r"(^(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    if (url.startsWith(r'www.')) {
      url =  'https://' + url;
    }
    return praseLink(url);
  }

  String praseLink(String url) {
    return Uri.parse(url).toString();
  }

  bool isValidEmail(String email){
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    // return emailRegExp.hasMatch(email);
    return EmailValidator.validate(email);
  }
}

class URLModel {
  String url;
  int startPos;
  int endPos;

  URLModel({
    required this.url,
    required this.startPos,
    required this.endPos,
  });
}
