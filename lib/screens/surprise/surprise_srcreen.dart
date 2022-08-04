import 'package:fyp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fyp/widgets/item/surprise_item_scrollview.dart';

class Surprise extends StatelessWidget {
  static const routeName = '/surprise';

  final imageURL = [
    'https://images.pexels.com/photos/193004/pexels-photo-193004.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    'https://images.pexels.com/photos/733857/pexels-photo-733857.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    'https://images.pexels.com/photos/1447254/pexels-photo-1447254.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/6481629/pexels-photo-6481629.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ];

  @override
  Widget build(BuildContext context) {
    // final routeArgs =
    //     ModalRoute.of(context).settings.arguments as Map<String, String>;
    // final id = routeArgs['id'];
    // final url = routeArgs['url'];
    double height = MediaQuery.of(context).size.height;
    // print('s '+ height.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('hi'),
      ),
      body: Container(
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(31, 162, 255, 1),
                Color.fromRGBO(189, 255, 243, 1),
                //Color.fromRGBO(18, 216, 250, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerLeft,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: SurpriseItemScrollView(imageURL.toList(), 5)),
                TextButton(
                  // onPressed: () =>  Navigator.pop(context,true),
                  onPressed: () =>   {
                    //Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false),
                    // Navigator.of(context).pushNamed(HomeScreen.routeName),
                    Navigator.pop(context,true),
                  },
                  child: Text('go back'),
                ),
              ],
            ),
          )),
    );
  }
}
