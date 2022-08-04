import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomeMenuScaffold extends StatefulWidget {
  final Widget menu;
  final Widget contentScreen;
  const HomeMenuScaffold(
      {Key? key, required this.menu, required this.contentScreen})
      : super(key: key);

  @override
  State<HomeMenuScaffold> createState() => _HomeMenuScaffoldState();
}

class _HomeMenuScaffoldState extends State<HomeMenuScaffold>
    with TickerProviderStateMixin {
  final Curve curveStyle = Curves.easeOut;
  double transformedWidth = 210;
  Curve transitionDownCurve = const Interval(0.0, 1.0, curve: Curves.linear);
  Curve scaleUpCurve = const Interval(0.0, 1.0, curve: Curves.linear);
  Curve transitionOutCurve = const Interval(0.0, 1.0, curve: Curves.linear);
  Curve transitionInCurve = const Interval(0.0, 1.0, curve: Curves.linear);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            body: GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(right: 210),
                  child: widget.menu,
                ),
                onTap: () {}),
          ),
          onTap: () {
            Provider.of<MenuController>(context, listen: false).toggle();
          },
        ),
        _buildContentScreen(),
      ],
    );
  }

  Widget _buildContentScreen() {
    return _buildTransformAnimation(widget.contentScreen);
  }

  Widget _buildTransformAnimation(Widget contentScreen) {
    double transitionPercent = 0, scalePercent = 0;

    switch (Provider.of<MenuController>(context, listen: true).state) {
      case MenuState.closed:
        transitionPercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        transitionPercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        transitionPercent = transitionOutCurve.transform(
            Provider.of<MenuController>(context, listen: true).openedPercent());
        scalePercent = transitionDownCurve.transform(
            Provider.of<MenuController>(context, listen: true).openedPercent());
        break;
      case MenuState.closing:
        transitionPercent = transitionInCurve.transform(
            Provider.of<MenuController>(context, listen: true).openedPercent());
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: true).openedPercent());
        break;
    }

    final double transitionAmount = transformedWidth * transitionPercent;
    final double contentScale = 1.0 - (0.25 * scalePercent);
    final double cornerRadius = 20.0 *
        Provider.of<MenuController>(context, listen: true).openedPercent();
    final BorderRadius containerBorderRadius =
        BorderRadius.circular(cornerRadius);

    return Transform(
      transform: Matrix4.translationValues(transitionAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: containerBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 0.5,
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: containerBorderRadius, child: contentScreen),
      ),
    );
  }
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    required this.vsync,
  }) : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double openedPercent() {
    return _animationController.value;
  }

  void open() {
    _animationController.forward();
  }

  void close() {
    _animationController.reverse();
  }

  void toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
