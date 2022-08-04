import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

import '../../user_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<Notification> notifications = [];
  String selectedNotification = "";

  bool _isLoading = true;

  bool _loadingError = false;
  String _errorMessage = "";

  void _getUserNotification() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response =
          await ApiManager.getInstance().get("/user/notification/$userID/1");
      if (response!['status'] == 1) {
        notifications = [];
        selectedNotification = response['result']['notification'];
        for (var notification in response['result']['notifications']) {
          if (selectedNotification == notification) {
            notifications.add(Notification(notification, true));
          } else {
            notifications.add(Notification(notification, false));
          }
        }

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
    }
    if (_loadingError) {
      await Utils.getInstance().showErrorDialog(context, _errorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateUserNotification() async {
    int userID = await UserInfo.getUserID();
    int status =
        notifications.map((e) => e.name).toList().indexOf(selectedNotification);
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .put("/user/notification/$userID/$status");
    await Utils.getInstance()
        .showSuccessDialog(context, response!['result']['message']);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getUserNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: _isLoading
          ? Container()
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

                              _getUserNotification();
                            },
                            child: const Text('Reload'))
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Column(
                    children: [
                      _buildInformation('Notification', selectedNotification,
                          () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, StateSetter localState) {
                            return SizedBox(
                              height: 150,
                              child: ListView.builder(
                                  itemCount: notifications.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      leading: Text(notifications[i].name),
                                      trailing: Checkbox(
                                        value: notifications[i].checked,
                                        onChanged: (bool? value) {
                                          localState(() {
                                            for (var element in notifications) {
                                              element.checked = false;
                                            }
                                            notifications[i].checked = true;
                                            setState(() {
                                              selectedNotification =
                                                  notifications[i].name;
                                            });
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            );
                          }),
                        );
                      }),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () => _updateUserNotification(),
                          child: const Text('Save'))
                      //_buildInformation('Notification', 'Open', () {}),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInformation(String title, String detail, Function()? onTap) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    detail,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[400]!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

class Notification {
  String name;
  bool checked;

  Notification(this.name, this.checked);
}
