import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/screens/home/home_screen.dart';
import 'package:fyp/screens/home/notification_screen.dart';
import 'package:fyp/screens/login/login_screen.dart';
import 'package:fyp/screens/menu/save_list_screen.dart';
import 'package:fyp/screens/menu/user_liked_screen.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/screens/post/post_item_screen.dart';
import 'package:fyp/screens/login/register_screen.dart';
import 'package:fyp/screens/Surprise/surprise_srcreen.dart';
import 'package:fyp/screens/TestScreen/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fyp/splash_screen.dart';
import 'package:fyp/user_info.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print(message.data);
  debugPrint('received message');
  //FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

AndroidNotificationChannel? channel;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

AndroidInitializationSettings? initializationSettingsAndroid;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await firebaseSetUp();
  await enableAndroidNotification();
  await requestNotificationPremission();
  await enableIOSNotifications();
  await showFirebaseToken();

  await getUserLocale();

  runApp(const MyApp());
}

Future<void> showFirebaseToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint("firebase token: " + token.toString());
}

Future<void> firebaseSetUp() async {
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> enableAndroidNotification() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);
  //initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
}

Future<void> enableIOSNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> requestNotificationPremission() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<Locale> getUserLocale() async {
  // //testing chinese
  // String userLocale = 'zh';
  // UserInfo.setUserLocale(userLocale);

  //testing english;
  String userLocale = 'en';
  UserInfo.setUserLocale(userLocale);
  //develop
  // String userLocale = await UserInfo.getUserLocale();
  // if (userLocale == "") {
  //   userLocale = Platform.localeName.substring(0, 2);
  //   if (!Globals.supportLocales.contains(userLocale)) {
  //     userLocale = 'en';
  //   }
  //   UserInfo.setUserLocale(userLocale);
  // }

  return Locale(userLocale);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {

      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    // int userID = await UserInfo.getUserID();
    if (message.data['type'] == '1') {
      // Navigator.pushNamed(_navKey.currentContext!, NotificationScreen.routeName);
      Navigator.push(
        _navKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => MessageScreen(
            creatorID: int.parse(message.data['creator']),
            receiverID: int.parse(message.data['receiver']),
            postID:  int.parse(message.data['postID']),
            roomID:  int.parse(message.data['roomID']),
            viewFromRoomMessage: true,
            receiverName: message.data['receiverName'],
          ),
        ),
      );
    }else if(message.data['type'] == 2){
      Navigator.pushNamed(context, NotificationScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (android != null && notification != null) {
        // var initializationSettingsAndroid =
        //     AndroidInitializationSettings('@mipmap/ic_launcher');
        // print('received');
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channelDescription: channel!.description,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        SplashScreen.routeName: (ctx) => const SplashScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        Surprise.routeName: (ctx) => Surprise(),
        QuestionScreen.routeName: (ctx) => const QuestionScreen(),
        Test.routeName: (ctx) => Test(),
        SaveListScreen.routeName: (ctx) => const SaveListScreen(),
        PostItemScreen.routeName: (ctx) => const PostItemScreen(),
        NotificationScreen.routeName: (ctx) => const NotificationScreen(),
        UserLikedItemScreen.routeName: (ctx) => const UserLikedItemScreen(),
      },
    );
  }
}
