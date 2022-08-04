import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/customs/login_clipPath.dart';
import 'package:fyp/helper/string_helper.dart';
import 'package:fyp/screens/login/login_screen.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _googleLoginUser;
  Map<String, dynamic>? _faceBookUser;
  AccessToken? _accessToken;
  int _registerType = 1;

  bool nameIncorrect = false;
  bool emailIncorrect = false;
  bool passwordIncorrect = false;
  String nameIncorrectMessage = "";
  String emailIncorrectMessage = "";
  String passwordIncorrectMessage = "";

  bool _loadingError = false;
  String _errorMessage = "";

  bool _emptyChecking() {
    if (nameController.text == "") {
      nameIncorrect = true;
      nameIncorrectMessage = "Cannot be blanked";
    } else {
      nameIncorrect = false;
    }
    if (emailController.text == "") {
      emailIncorrect = true;
      emailIncorrectMessage = "Cannot be blanked";
    } else {
      emailIncorrect = false;
    }
    if (passwordController.text == "") {
      passwordIncorrect = true;
      passwordIncorrectMessage = "Cannot be blanked";
    } else {
      passwordIncorrect = false;
    }
    setState(() {});
    if (!nameIncorrect && !emailIncorrect && !passwordIncorrect) {
      return true;
    } else {
      return false;
    }
  }

  bool _validEmail() {
    if (StringHelper.getInstance()!.isValidEmail(emailController.text)) {
      emailIncorrect = false;
      emailIncorrectMessage = "";
    } else {
      emailIncorrect = true;
      emailIncorrectMessage = "Invalid Type of Email";
    }
    setState(() {});
    return !emailIncorrect;
  }

  Future<void> _register() async {
    Utils.getInstance().showLoadingDialog(context);
    try {
      Map<String, dynamic>? response;
      if (_registerType == 1) {
        var formDataMap = {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'login_type': _registerType,
        };
        response = await ApiManager.getInstance()
            .post("/user/register/", formDataMap: formDataMap);
        // Utils.getInstance().closeLoadingDialog(context);
        // if (response!['status'] == 1) {
        //   await Utils.getInstance()
        //       .showSuccessDialog(context, response['result']['message']);
        //   Navigator.popAndPushNamed(context, LoginScreen.routeName);
        // }
      } else if (_registerType == 2) {
        var formDataMap = {
          'name': _googleLoginUser!.displayName,
          'email': _googleLoginUser!.email,
          'login_id': _googleLoginUser!.id,
          'login_type': _registerType,
        };
        response = await ApiManager.getInstance()
            .post("/user/register/", formDataMap: formDataMap);
      } else if (_registerType == 3) {
        var formDataMap = {
          'name': _faceBookUser!['name'],
          'email': _faceBookUser!['email'],
          'login_id': _faceBookUser!['id'],
          'login_type': _registerType,
        };
        response = await ApiManager.getInstance()
            .post("/user/register/", formDataMap: formDataMap);
      }
      debugPrint(response.toString());
      if (response!['status'] == 1) {
        Utils.getInstance().closeLoadingDialog(context);
        await Utils.getInstance()
            .showSuccessDialog(context, response['result']['message']);
        Navigator.popAndPushNamed(context, LoginScreen.routeName);
      }
    } on DioError catch (e) {
      AppLocalizations localization = AppLocalizations.of(context)!;
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
        Utils.getInstance().closeLoadingDialog(context);
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
      } else if (e.response!.statusCode == 400) {
        var errorResponse = e.response!.data;
        String errorMessage = errorResponse['result']['error_message'];
        Utils.getInstance().closeLoadingDialog(context);
        if (_registerType == 2 || _registerType == 3) {
          Utils.getInstance().closeLoadingDialog(context);
        }
        await Utils.getInstance().showErrorDialog(context, errorMessage);
      }
    }
  }

  Future<void> _signWithGoogle() async {
    _googleLoginUser = await _googleSignIn.signIn();
    Utils.getInstance().showLoadingDialog(context);
    // debugPrint(_googleLoginUser.toString());
  }

  Future<void> _signWithFacebook() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();

      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _faceBookUser = userData;
      await _register();
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
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
                              'Register',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Sign up to join the convience trading process',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        _buildInput('Username', nameController),
                        _buildInput('Password', passwordController,
                            isPassword: true),
                        _buildInput('Email', emailController),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent),
                            child: const Text('Register'),
                            onPressed: () {
                              _registerType = 1;
                              if (_emptyChecking()) {
                                if (_validEmail()) {
                                  _register();
                                }
                              }
                            },
                          ),
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
                        SizedBox(
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Sign Up with Google",
                            onPressed: () async {
                              _registerType = 2;
                              await _signWithGoogle();
                              if (_googleLoginUser != null) {
                                await _register();
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
                            text: "Sign Up with Facebook",
                            onPressed: () async {
                              _registerType = 3;
                              await _signWithFacebook();
                            },
                          ),
                        ),
                        const Spacer(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: const Text(
                                  'I already have a account ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.routeName);
                                },
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                            ]),
                        const SizedBox(
                          height: 30,
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

  Widget _buildInput(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? true : false,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
            ),
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
