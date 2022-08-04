import 'package:flutter/material.dart';

import 'dart:math' as math;

class RadialExpansion extends StatelessWidget {
  final double maxRadius;
  final clipRectSize;
  final Widget? child;


  RadialExpansion({
    Key? key,
    required this.maxRadius,
    this.child,
  }) : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
       super(key: key);


  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          // child: ClipRect(
          //   child: child,  // Photo
          // ),
          child : child,
        ),
      ),
    );
  }
}