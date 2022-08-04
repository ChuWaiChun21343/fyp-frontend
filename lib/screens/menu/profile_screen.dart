import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/user/user.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/common/common_dropdown_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../user_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int showModalIndex = 1;

  bool _isLoading = true;
  bool _editAll = false;
  bool editUserName = false;
  bool editGender = false;
  bool editAge = false;
  bool editEmail = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late List<bool> edits = [editUserName, editGender, editAge, editEmail];
  late List<TextEditingController> cotrollers = [
    usernameController,
    genderController,
    ageController,
    emailController
  ];
  List<String> genders = [];
  List<bool> gendersCheck = [false, false, false];
  String username = "";
  String createDate = "";
  String gender = "";
  String age = "";
  String email = "";
  String postedNumber = "0";
  String likedPostNumber = "0";

  bool userNameError = false;
  bool genderError = false;
  bool ageError = false;
  bool emailError = false;

  String userNameErrorMessage = "";
  String genderErrorMessage = "";
  String ageErrorMessage = "";
  String emailErrorMessage = "";

  bool _loadingError = false;
  String _errorMessage = "";

  void _getUserInformation() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response =
          await ApiManager.getInstance().get("/user/get-user/$userID");
      if (response!['status'] == 1) {
        User user = User.fromJson(response['result']);
        username = user.name;
        createDate = user.createDate;
        gender = user.gender;
        genders = user.genders;
        age = user.age.toString();
        email = user.email;
        postedNumber = user.postedNumber.toString();
        likedPostNumber = user.likedNumber.toString();
        usernameController.text = username;
        genderController.text = gender;
        emailController.text = email;
        ageController.text = age;
        gendersCheck[genders.indexOf(gender)] = true;
        setState(() {
          _loadingError = false;
          _isLoading = false;
        });
      }
    } on DioError catch (e) {
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
      }
      if (_loadingError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateUserInformation() async {
    Utils.getInstance().showLoadingDialog(context);
    int userID = await UserInfo.getUserID();
    // bool isInteger = int.tryParse(ageController.text) == null;
    // String age = ageController.text;
    // if (!isInteger) {
    //   age = "-1";
    // }
    int genderIndex = 0;
    for (var i = 0; i < gendersCheck.length; i++) {
      if (gendersCheck[i]) {
        genderIndex = i;
      }
    }
    var formDataMap = {
      'name': usernameController.text,
      'gender': genderIndex,
      'age': ageController.text,
      'email': emailController.text,
    };
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .post("/user/update-user/$userID", formDataMap: formDataMap);
    if (response!['status'] == 1) {
      Utils.getInstance().closeDialog(context);
      String message = response['result']['message'];
      await Utils.getInstance().showConfrimMessage(context, message);
    }
  }

  bool _hasEmptyInput() {
    if (emailController.text == "") {
      emailError = true;
      emailErrorMessage = "Cannot be empty";
    }
    return userNameError || genderError || ageError || emailError;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getUserInformation();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: CommonAppBar(
        leadingWidget: InkWell(
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        title: '',
        trailingWidgets: [
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: const Icon(
                MdiIcons.accountEdit,
                color: Colors.black,
              ),
            ),
            onTap: () {
              _editAll = !_editAll;
              for (int i = 0; i < edits.length; i++) {
                if (i != showModalIndex) {
                  edits[i] = _editAll;
                }
              }
              setState(() {});
            },
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _loadingError
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage),
                        const SizedBox(
                          height: 5,
                        ),
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              _getUserInformation();
                            },
                            child: const Text('Reload'))
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    'https://images.pexels.com/photos/193004/pexels-photo-193004.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                                // child: Icon(
                                //   Icons.person,
                                //   color: Colors.grey,
                                //   size: 80,
                                // ),
                                //child: Image.network('https://images.pexels.com/photos/193004/pexels-photo-193004.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',fit: BoxFit.fill,),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Created in ' + createDate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 80,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildItemInformation(
                                          'Posted Item', postedNumber,
                                          needLine: true),
                                    ),
                                    Expanded(
                                      child: _buildItemInformation(
                                          'Liked Item', likedPostNumber),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildPersonalInformationList(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: height * 0.85),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () {
                                if (!_hasEmptyInput()) {
                                  _updateUserInformation();
                                } else {}
                                setState(() {});
                              },
                              child: Text('Save'))),
                    ],
                  ),
                ),
    );
  }

  Widget _buildItemInformation(String title, String detail,
      {bool needLine = false}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: needLine
          ? const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            )
          : null,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detail,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationList() {
    return Column(
      children: [
        _buildPersonalInformation('Gender:', gender, 1, isDropdown: true),
        _buildPersonalInformation('Age:', age, 2, isNumber: true),
        _buildPersonalInformation('Email:', email, 3),
      ],
    );
  }

  Widget _buildPersonalInformation(String title, String detail, int index,
      {bool isNumber = false, bool isDropdown = false}) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.black.withOpacity(0.17),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                      ),
                      onTap: () async {
                        if (index == showModalIndex) {
                          await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  StatefulBuilder(
                                    builder: (context, StateSetter localState) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                kBottomNavigationBarHeight / 2),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: genders.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CheckboxListTile(
                                                title: Text(genders[index]),
                                                value: gendersCheck[index],
                                                onChanged: (bool? value) {
                                                  localState(() {
                                                    gendersCheck = gendersCheck
                                                        .map((e) => false)
                                                        .toList();
                                                    gendersCheck[index] =
                                                        value!;
                                                    gender = genders[index];
                                                    genderController.text =
                                                        genders[index];
                                                  });
                                                },
                                              );
                                            }),
                                      );
                                    },
                                  ));
                        }
                        setState(() {
                          edits[index] = !edits[index];
                        });
                      },
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  ],
                ),
                const Spacer(),
                edits[index] && index != showModalIndex
                    ? TextFormField(
                        readOnly: index == showModalIndex ? true : false,
                        controller: cotrollers[index],
                        keyboardType: isNumber ? TextInputType.number : null,
                        // inputFormatters: isNumber
                        //     ? <TextInputFormatter>[
                        //         FilteringTextInputFormatter.allow(
                        //             RegExp(r'[0-9]')),
                        //         TextInputFormatter.withFunction(
                        //             (oldValue, newValue) {
                        //           try {
                        //             print(newValue);
                        //             if (int.parse(newValue.text) > 120) {
                        //               ageController.text = oldValue.text;
                        //               return oldValue;
                        //             } else {
                        //               if (int.parse(oldValue.text) == 0) {
                        //                 return TextEditingValue(
                        //                     text: newValue.text
                        //                         .replaceFirst("0", "")
                        //                         .toString());
                        //               }
                        //               ageController.text = newValue.text;
                        //               return newValue;
                        //             }
                        //           } catch (e) {
                        //             ageController.text = "";
                        //             return const TextEditingValue(text: "");
                        //           }
                        //         })
                        //       ]
                        //     : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 5),
                        ),
                      )
                    : Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
