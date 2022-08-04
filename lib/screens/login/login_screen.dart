import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/user/user.dart';

//screen
import 'package:fyp/screens/home/home_screen.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/screens/login/register_screen.dart';
import 'package:fyp/screens/TestScreen/test.dart';
import 'package:fyp/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

//widget
import 'package:fyp/animation/shake_widget.dart';
import 'package:fyp/customs/login_clipPath.dart';

import '../../user_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool emailIncorrect = false;
  bool passwordIncorrect = false;
  bool emailShake = false;
  bool passwordShake = false;
  Key emailkey = UniqueKey();
  Key passwordKey = UniqueKey();
  String emailIncorrectMessage = "";
  String passwordIncorrectMessage = "";
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _googleLoginUser;
  Map<String, dynamic>? _faceBookUser;
  AccessToken? _accessToken;

  int loginType = 1;

  bool _loadingError = false;
  String _errorMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool _loginChecking() {
    if (emailController.text == "") {
      setState(() {
        emailIncorrect = true;
        emailShake = true;
        emailIncorrectMessage = "Cannot be blanked";
        emailkey = UniqueKey();
      });
    } else {
      setState(() {
        emailIncorrect = false;
        emailShake = false;
      });
    }
    if (passwordController.text == "") {
      setState(() {
        passwordIncorrect = true;
        passwordShake = true;
        passwordIncorrectMessage = "Cannot be blanked";
        passwordKey = UniqueKey();
      });
    } else {
      setState(() {
        passwordIncorrect = false;
        passwordShake = false;
      });
    }
    if (!emailIncorrect && !passwordIncorrect) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _login() async {
    // FocusScope.of(context).unfocus();

    AppLocalizations localization = AppLocalizations.of(context)!;

    try {
      Map<String, dynamic>? response;
      final token = await FirebaseMessaging.instance.getToken();
      if (loginType == 1) {
        if (_loginChecking()) {
          var formDataMap = {
            'email': emailController.text,
            'password': passwordController.text,
            'login_type': loginType,
          };
          formDataMap['token'] = token.toString();
          response = await ApiManager.getInstance()
              .post("/user/login/", formDataMap: formDataMap);
        } else {
          Utils.getInstance().closeLoadingDialog(context);
          return;
        }
      } else if (loginType == 2) {
        var formDataMap = {
          'name': _googleLoginUser!.displayName,
          'email': _googleLoginUser!.email,
          'login_id': _googleLoginUser!.id,
          'login_type': loginType,
        };
        formDataMap['token'] = token.toString();
        response = await ApiManager.getInstance()
            .post("/user/login", formDataMap: formDataMap);
      } else if (loginType == 3) {
        var formDataMap = {
          'name': _faceBookUser!['name'],
          'email': _faceBookUser!['email'],
          'login_id': _faceBookUser!['id'],
          'login_type': loginType,
        };
        formDataMap['token'] = token.toString();
        response = await ApiManager.getInstance()
            .post("/user/login", formDataMap: formDataMap);
      }
      if (response!['status'] == 1) {
        Utils.getInstance().closeLoadingDialog(context);
        UserInfo.setUserID(response['result']['user']['id']);
        UserInfo.setLoginStatus(true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      }
    } on DioError catch (e) {
      String connectionError = localization.connectionError;
      String connectTimeoutError = localization.connectTimeoutError;
      String receiveTimeoutError = localization.receiveTimeoutError;
      String othersError = localization.otherError;
      bool loginError = false;
      Utils.getInstance().closeLoadingDialog(context);
      var errorResponse = e.response!.data;
      if (e.response == null) {
        print('hoi');
        _loadingError = true;
        if (e.type == DioErrorType.connectTimeout) {
          _errorMessage = connectTimeoutError;
        } else if (e.type == DioErrorType.receiveTimeout) {
          _errorMessage = receiveTimeoutError;
        } else if (e.type == DioErrorType.other) {
          _errorMessage = othersError;
        }
      } else if (e.response!.statusCode == 400) {
        loginError = true;
        String errorMessage = errorResponse['result']['error_message'];
        await Utils.getInstance().showErrorDialog(context, errorMessage);
        if (errorResponse['status'] == 0) {
          if (loginType == 1) {
            emailIncorrect = true;
            emailShake = true;
            emailkey = UniqueKey();
            passwordIncorrect = true;
            passwordShake = true;
            passwordKey = UniqueKey();
          }

          if (loginType == 1) {
            setState(() {
              emailIncorrectMessage = errorMessage;
              passwordIncorrectMessage = errorMessage;
            });
          }
        }
      }
      if (_loadingError && !loginError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {});
      }
    }
    // Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

  void _register(BuildContext context) {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  double shakeAnimation(double animation) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());

  Future<void> _signWithGoogle() async {
    _googleLoginUser = await _googleSignIn.signIn();
    debugPrint(_googleLoginUser.toString());
  }

  Future<void> _signWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final accessToken = await FacebookAuth.instance.accessToken;
    print(result.status.toString());

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _faceBookUser = userData;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipPath(
                    clipper: LoginClipPath(),
                    child: Container(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: const Text(
                              'Welcome',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Please Login to explore different things',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ShakeWidget(
                          key: emailkey,
                          shake: emailShake,
                          child: TextFormField(
                            // autofocus: true,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'email',
                              errorText:
                                  emailIncorrect ? emailIncorrectMessage : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ShakeWidget(
                          key: passwordKey,
                          shake: passwordShake,
                          child: TextFormField(
                            // autofocus: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'password',
                              errorText: passwordIncorrect
                                  ? passwordIncorrectMessage
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     child: const Text('Forget Password'),
                        //     onPressed: () {},
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: const Text('Login'),
                              onPressed: () async {
                                loginType = 1;
                                Utils.getInstance().showLoadingDialog(context);
                                await _login();
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.grey[600],
                          )),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("OR"),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.grey[600],
                          )),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.Google,
                            onPressed: () async {
                              await _signWithGoogle();
                              if (_googleLoginUser != null) {
                                loginType = 2;
                                Utils.getInstance().showLoadingDialog(context);
                                await _login();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.FacebookNew,
                            onPressed: () async {
                              await _signWithFacebook();
                              loginType = 3;
                              if (_faceBookUser != null) {
                                await _login();
                              }
                            },
                          ),
                        ),
                        // TextButton(
                        //   onPressed: () =>
                        //       Navigator.of(context).pushNamed(Test.routeName),
                        //   child: const Text('test'),
                        // ),
                        const Spacer(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have a account? ',
                                style: TextStyle(fontSize: 14),
                              ),
                              InkWell(
                                child: const Text(
                                  'Create Now',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.routeName);
                                },
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                            ]),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
