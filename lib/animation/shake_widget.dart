import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class ShakeWidget extends StatefulWidget {
  final Key? key;
  final Duration duration;
  final double deltaX;
  final Curve curve;
  final Widget? child;
  final bool? shake;

  ShakeWidget(
      {
      this.key,
      this.duration = const Duration(milliseconds: 500),
      this.deltaX = 20,
      this.curve = Curves.bounceOut,
      this.child,
      this.shake});

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> {
  double shakeAnimation(double animation) => widget.shake! ? 
      2 * (0.5 - (0.5 - widget.curve.transform(animation)).abs()) : 0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: widget.key,
      tween: widget.shake! ? Tween(begin: 0.0, end: 1.0) : Tween(begin: 0.0, end: 0.0),
      duration: widget.duration,
      builder: (context, animation, child) => Transform.translate(
        offset:  Offset(widget.deltaX * shakeAnimation(animation), 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
