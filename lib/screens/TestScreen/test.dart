import 'package:fyp/screens/Surprise/surprise_srcreen.dart';
import 'package:fyp/widgets/animate/custom_wheel.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/item/detail_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp/widgets/common/bottom_navigation_bar.dart';

class Test extends StatefulWidget {
  static const routeName = '/test';

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool expandPlace = false;
  late AnimationController expandController;
  late Animation<double> expandAnimation;

  void _setUpAnimationController() {
    Duration duration = const Duration(microseconds: 500);
    expandController = AnimationController(vsync: this, duration: duration);
    expandAnimation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _expandPlaceContainer() {
    if (expandPlace) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _setUpAnimationController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    expandController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    _expandPlaceContainer();
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height - kBottomNavigationBarHeight;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        leadingWidget: InkWell(
          child: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            setState(() {
              expandPlace = !expandPlace;
            });

            print('hi');
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.height * 0.9,
            //       child: DetailItemDialog(
            //         id: "0",
            //         url: "",
            //       ),
            //     ),
            //     TextButton(
            //       onPressed: () =>
            //           Navigator.of(context).pushNamed(Surprise.routeName),
            //       child: Text('hi'),
            //     ),
            //   ],
            // ),
            // child: Container(
            //   height: height,
            //   width: width,
            //   padding: const EdgeInsets.all(20),
            //   child: CustomWheel(number: 5),
            // ),
            child: ExpandedSection(
          child: Text('hi'),
          expand: expandPlace,
        )),
      ),
      bottomNavigationBar: CustomerBottomNavigation(),
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  ExpandedSection({this.expand = false, required this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation<double> curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
