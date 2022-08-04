import 'package:flutter/material.dart';

class RotateWidget extends StatefulWidget {
  final Widget child;
  final bool rotate;
  const RotateWidget({
    Key? key,
    required this.child,
    required this.rotate,
  }) : super(key: key);

  @override
  State<RotateWidget> createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  void _setUpAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      upperBound: 0.5,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(expandController);
  }

  @override
  void initState() {
    super.initState();
    _setUpAnimations();
  }

  @override
  void didUpdateWidget(RotateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rotate != widget.rotate) {
      if (widget.rotate) {
        expandController.forward(from: 0);
      } else {
        expandController.reverse(from: 0.5);
      }
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: animation, child: widget.child);
  }
}
