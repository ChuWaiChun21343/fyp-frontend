import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/string_helper.dart';
import 'dart:io' show Platform;
import 'package:numberpicker/numberpicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static Utils? _instance;

  //private constructor
  Utils._();

  factory Utils() {
    return _instance!;
  }

  static Utils getInstance() {
    _instance ??= Utils._();
    return _instance!;
  }

  void showLoadingDialog(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String loadingMessage = localization.loading;
    final String note = localization.note;
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 3),
                        width: 32,
                        height: 32),
                    Text(loadingMessage),
                  ],
                ),
              ),
            );
          });
    } else if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                note,
                style: const TextStyle(fontSize: 20),
              ),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    const SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 3),
                        width: 32,
                        height: 32),
                    Text(loadingMessage),
                  ],
                ),
              ),
            );
          });
    }
  }

  void closeLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void closeDialog(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> showInpuWarningDialog(BuildContext context, String emptySlot,
      String userLocale, String comma) async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String note = localization.note;
    final String confirm = localization.confirm;
    final String cannotEmpty = localization.cannotBeEmpty.toLowerCase();
    if (emptySlot.endsWith(comma)) {
      emptySlot =
          emptySlot.replaceRange(emptySlot.length - 1, emptySlot.length, '');
      if (userLocale == 'en') {
        emptySlot += ' ';
      }
    }
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            note,
            style: const TextStyle(fontSize: 20),
          ),
          content: Text('$emptySlot$cannotEmpty'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text(confirm),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              note,
              style: const TextStyle(fontSize: 20),
            ),
            content: Text('$emptySlot$cannotEmpty'),
            actions: [
              TextButton(
                child: Text(confirm),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String note = localization.note;
    final String confirm = localization.confirm;
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            note,
            style: const TextStyle(fontSize: 20),
          ),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text(confirm),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              confirm,
              style: const TextStyle(fontSize: 20),
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(confirm),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> showSuccessDialog(BuildContext context, String message,
      {bool containTitle = true}) async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String note = localization.note;
    final String confirm = localization.confirm;
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: containTitle
              ? Text(
                  note,
                  style: const TextStyle(fontSize: 20),
                )
              : Container(),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text(confirm),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: containTitle
                ? Text(
                    note,
                    style: const TextStyle(fontSize: 20),
                  )
                : Container(),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(confirm),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> showConfrimMessage(
    BuildContext context,
    String message, {
    bool containTitle = true,
    String confirmButton = '',
    String cancelButton = '',
  }) async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String remind = localization.remind;
    confirmButton = confirmButton == '' ? localization.confirm : confirmButton;
    cancelButton = cancelButton == '' ? localization.cancel : cancelButton;
    bool confirm = true;
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: containTitle
              ? Text(
                  remind,
                  style: const TextStyle(fontSize: 20),
                )
              : Container(),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text(confirmButton),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            CupertinoDialogAction(
              child: Text(cancelButton),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, false);
                confirm = false;
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: containTitle
                ? Text(
                    remind,
                    style: const TextStyle(fontSize: 20),
                  )
                : Container(),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(confirmButton),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text(cancelButton),
                onPressed: () {
                  Navigator.pop(context, false);
                  confirm = false;
                },
              ),
            ],
          );
        },
      );
    }
    return confirm;
  }

  Future<void> showCustomWordMessage(
      BuildContext context, String message, String buttonMessage,
      {String title = ''}) async {
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: title != ''
              ? Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                )
              : Container(),
          content: Text(message),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: Text(buttonMessage),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != ''
                ? Text(
                    message,
                    style: const TextStyle(fontSize: 20),
                  )
                : Container(),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(buttonMessage),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    }
  }



  void showDateMonthYearPicker(
      BuildContext context,
      DateTime? initalTime,
      DateTime? startingTime,
      DateTime endingTime,
      Function(DateTime) dateTimechange) {
    //initalTime ??= DateTime.utc( DateTime.now().year,DateTime.now().month,DateTime.now().day);
    if (initalTime == null && startingTime != null) {
      initalTime = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    } else if (initalTime != null && startingTime == null) {
      startingTime = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
    } else if (initalTime == null && startingTime == null) {
      initalTime ??= DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      startingTime = initalTime;
    }
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: initalTime,
              minimumDate: startingTime,
              maximumDate: endingTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: dateTimechange,
            ),
          ),
        ],
      ),
    );
  }

  void showNumberPicker(BuildContext context, int value, int minValue,
      int maxValue, int step, Function(int) numberOnChange) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final String note = localization.note;
    final String confirm = localization.confirm;

    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                note,
                style: const TextStyle(fontSize: 20),
              ),
              //as the dialog is outside the screen context,call the statefulBuilder to use StateSetter to help to rebuild state in the dialog.
              //use the flutter inspector the view the widget.
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter buildOnchange) {
                return NumberPicker(
                  value: value,
                  maxValue: maxValue,
                  minValue: minValue,
                  step: step,
                  onChanged: (currentValue) {
                    buildOnchange(() {
                      value = currentValue;
                    });
                    numberOnChange(currentValue);
                  },
                );
              }),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: Text(confirm),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
    // showCupertinoModalPopup(
    //   context: context,
    //   builder: (context) => CupertinoActionSheet(
    //     actions: [
    //       SizedBox(
    //         height: 200,
    //         child: NumberPicker(
    //           value: value,
    //           maxValue: maxValue,
    //           minValue: minValue,
    //           step: step,
    //           onChanged: numberOnChange,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Future<void> lanuchWeb(String url) async {
    url = url.trim();
    url = StringHelper.getInstance()!.getLink(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('cannot lanuch $url');
    }
  }

  Future<void> lanuchPhone(String phone) async {
    final Uri phoneUrl = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launch(phoneUrl.toString());
  }

  Future<void> lanuchEmail(String email) async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(emailUrl.toString());
  }

  // void showDialogWithFucntion(BuildContext context, String message,
  //     String functionMessage, Map<String, dynamic> formDataMap) async {
  //   if (Platform.isIOS) {
  //     showCupertinoDialog(
  //       context: context,
  //       builder: (context) => CupertinoAlertDialog(
  //         title: const Text(
  //           '提示',
  //           style: TextStyle(fontSize: 20),
  //         ),
  //         content: Text('你的戶口正等待電郵認証，如未能收到認電郵，請按 \'重新傳送確認電郵\''),
  //         actions: <CupertinoDialogAction>[
  //           CupertinoDialogAction(
  //             child: const Text('確認'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             child: const Text('重新傳送確認電郵'),
  //             onPressed: () async {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               showLoadingDialog(context);
  //               ApiManager.getInstance()
  //                   .post("api.php?p=member/resend_verify_byEamil",
  //                       formDataMap: formDataMap)
  //                   .then((response) {
  //                 print(response);
  //                 if (response['status'] == 1) {
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                   Navigator.pushNamed(context, SuccessScreen.routeName,
  //                       arguments: new Success('成功重新傳送確認電郵',
  //                           '確認電郵已傳送您的郵箱。點選信中的連結確認您的註冊。\n\n我們將有專人與您聯絡', ''));
  //                 }
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if (Platform.isAndroid) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text(
  //             '提示',
  //             style: TextStyle(fontSize: 20),
  //           ),
  //           content: Text('你的戶口正等待電郵認証，如未能收到認電郵，請按 \'重新傳送確認電郵\''),
  //           actions: [
  //             TextButton(
  //               child: const Text('確認'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             TextButton(
  //               child: const Text('重新傳送確認電郵'),
  //               onPressed: () async {
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 showLoadingDialog(context);
  //                 ApiManager.getInstance()
  //                     .post("api.php?p=member/resend_veridickyfy_byEamil",
  //                         formDataMap: formDataMap)
  //                     .then((response) {
  //                   print(response);
  //                   if (response['status'] == 1) {
  //                     Navigator.of(context, rootNavigator: true).pop();
  //                     Navigator.pushNamed(context, SuccessScreen.routeName,
  //                         arguments: new Success('成功重新傳送確認電郵',
  //                             '確認電郵已傳送您的郵箱。點選信中的連結確認您的註冊。\n\n我們將有專人與您聯絡', ''));
  //                   }
  //                 });
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
}
