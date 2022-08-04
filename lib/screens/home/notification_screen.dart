import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/models/notification/notification_message.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  List<NotificationMessage> notificationMessages = [];

  bool _loadingError = false;
  String _errorMessage = "";

  void _getNotification() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response = await ApiManager.getInstance()
          .get("/notification/get-admin-notification-by-user/$userID");
      if (response!['status'] == 1) {
        for (var notificationMessageJson in response['result']) {
          NotificationMessage notificationMessage =
              NotificationMessage.fromJson(notificationMessageJson);
          notificationMessages.add(notificationMessage);
        }
        setState(() {
          _isLoading = false;
        });
        ApiManager.getInstance().put(
            "/notification/update-user-notification-view",
            formDataMap: {'user_id': userID});
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        leadingWidget: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Container()
          : notificationMessages.isEmpty
              ? const Center(child: Text('No notification has been found'))
              : Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 150),
                      itemCount: notificationMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildNotificationInformation(
                          notificationMessages[index],
                        );
                      }),
                ),
    );
  }

  Widget _buildNotificationInformation(
      NotificationMessage notificationMessage) {
    double iconSpace = 20;
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: iconSpace,
            ),
            child: Text(
              notificationMessage.postDate,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: notificationMessage.view == 0,
                child: SizedBox(
                  width: iconSpace,
                  child: const Icon(
                    Icons.circle,
                    color: Colors.lightBlue,
                    size: 10,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  notificationMessage.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: notificationMessage.view == 0
                        ? Colors.lightBlue
                        : Colors.grey,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(
              left: iconSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notificationMessage.content,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
