import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/screens/login/login_screen.dart';
import 'package:fyp/screens/menu/history_list_screen.dart';
import 'package:fyp/screens/menu/posted_list_screen.dart';
import 'package:fyp/screens/menu/profile_screen.dart';
import 'package:fyp/screens/menu/receive_item_list_screen.dart';
import 'package:fyp/screens/menu/save_list_screen.dart';
import 'package:fyp/screens/menu/setting_screen.dart';
import 'package:fyp/screens/menu/user_liked_screen.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/screens/message/total_post_message_room_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              10, AppBar().preferredSize.height + 10, 10, 0),
          child: SizedBox(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCategoryContainer(
                        const Icon(Icons.person_outlined),
                        'Profile',
                        () {
                          _animateNavigator(const ProfileScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(Icons.party_mode_outlined),
                        'Posted',
                        () {
                          _animateNavigator(const PostedListScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(Icons.label_important_outline),
                        'Saved',
                        () {
                          _animateNavigator(const SaveListScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(Icons.history),
                        'History',
                        () {
                          _animateNavigator(const HistoryListScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(Icons.message_rounded),
                        'Message',
                        () {
                          _animateNavigator(const TotalPostMessageRoomScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(MdiIcons.thumbUpOutline),
                        'User Liked your Item',
                        () {
                          _animateNavigator(const UserLikedItemScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(MdiIcons.gift),
                        'Obtained Item',
                        () {
                          _animateNavigator(const ReceiveItemListScreen());
                        },
                      ),
                      _buildCategoryContainer(
                        const Icon(Icons.settings),
                        'Setting',
                        () {
                          _animateNavigator(const SettingScreen());
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildCategoryContainer(
                    const Icon(Icons.logout_rounded),
                    'Logout',
                    () async {
                      final token = await FirebaseMessaging.instance.getToken();
                      ApiManager.getInstance().put("/user/user-logout",
                          formDataMap: {
                            'token': token
                          }).then((value) => print(value));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (Route<dynamic> route) => false);
                      UserInfo.setLoginStatus(false);
                    },
                    sizeSpace: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _animateNavigator(Widget destinationPage) {
    Navigator.of(context).push(_popFromDownRoute(destinationPage));
  }

  Route _popFromDownRoute(Widget destinationPage) {
    Duration popUpDuration = const Duration(milliseconds: 500);
    Duration closeDownDuration = const Duration(milliseconds: 400);
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionDuration: popUpDuration,
      reverseTransitionDuration: closeDownDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuad;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget _buildCategoryContainer(Icon icon, String title, Function() onTap,
      {double sizeSpace = 30}) {
    return Column(
      children: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: [
                Expanded(flex: 4, child: icon),
                Expanded(
                  flex: 9,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: onTap,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        SizedBox(
          height: sizeSpace,
        ),
      ],
    );
  }
}
