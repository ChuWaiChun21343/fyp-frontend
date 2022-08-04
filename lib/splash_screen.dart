// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/screens/home/home_screen.dart';
import 'package:fyp/screens/login/login_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loadingError = false;
  String _errorMessage = "";
  void saveUserToken() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    bool isSavedToken = await UserInfo.getSavedToken();

    if (!isSavedToken) {
      final token = await FirebaseMessaging.instance.getToken();
      var formDataMap = {
        'token': token.toString(),
      };
      try {
        await ApiManager.getInstance()
            .post("/user/save-non-member-token", formDataMap: formDataMap);
        UserInfo.setSavedToken(true);
      } on DioError catch (e) {
        String connectionError = localization.connectionError;
        String connectTimeoutError = localization.connectTimeoutError;
        String receiveTimeoutError = localization.receiveTimeoutError;
        String othersError = localization.otherError;

        if (e.response == null) {
          _loadingError = true;
          if (e.type == DioErrorType.connectTimeout) {
            _errorMessage = connectTimeoutError;
          } else if (e.type == DioErrorType.receiveTimeout) {
            _errorMessage = receiveTimeoutError;
          } else if (e.type == DioErrorType.other) {
            _errorMessage = othersError;
          }
        } else if (e.response!.statusCode == 400) {
          // print('error');
        }
        if (_loadingError) {
          await Utils.getInstance().showErrorDialog(context, _errorMessage);
          setState(() {
            // _isLoading = false;
          });
        }
      }
    }
    await Future.delayed(const Duration(seconds: 1), () {});

    UserInfo.getFirstTimeUseApp().then((isFirstTime) async {
      if (isFirstTime) {
        Navigator.pop(context);
        Navigator.pushNamed(context, LoginScreen.routeName);
        UserInfo.setFirstTimeUseApp(false);
      } else {
        bool isLogin = await UserInfo.getLoginStatus();
        if (isLogin) {
          Navigator.pop(context);
          Navigator.pushNamed(context, HomeScreen.routeName);
        } else {
          Navigator.pop(context);
          Navigator.pushNamed(context, LoginScreen.routeName);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      saveUserToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
            'https://assets7.lottiefiles.com/private_files/lf30_rlssnwpv.json'),
      ),
    );
  }
}
