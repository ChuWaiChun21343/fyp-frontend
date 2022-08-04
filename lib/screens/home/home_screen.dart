import 'package:fyp/screens/home/home_content_screen.dart';
import 'package:fyp/screens/home/home_menu.dart';
import 'package:fyp/screens/home/home_menu_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late MenuController menuController;
  
  @override
  void initState() {
    super.initState();
    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => menuController,
        child: const HomeMenuScaffold(
            menu:  HomeMenu(),
            contentScreen: HomeContentScreen(),
            ));
  }
}
