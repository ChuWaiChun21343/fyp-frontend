import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomWheel extends StatefulWidget {
  final int number;
  const CustomWheel({Key? key, required this.number}) : super(key: key);

  @override
  State<CustomWheel> createState() => _CustomWheelState();
}

class _CustomWheelState extends State<CustomWheel> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Wheel(number: widget.number),
    );
  }
}

class Wheel extends CustomPainter {
  final int number;
  const Wheel({
    required this.number,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final Rect rect = Offset.zero & size;

    drawArc(canvas, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawArc(Canvas canvas, Rect rect) {
    
    final widthCenter = rect.size.width / 2;
    final heightCenter = rect.size.height / 2;

    final center = Offset(widthCenter, heightCenter);
    double degToRad(num deg) => deg * (math.pi / 180.0);
    double eachAngle = 360/5;
    double sweepAngle = 360 / number;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Offset startingP2 = Offset(widthCenter, heightCenter / 2);
    Offset endingP2 = Offset(rect.size.width, heightCenter - math.pi * math.sin(degToRad(eachAngle)));
    print(endingP2.toString());
    // for(int i =0 ; i < number ;i ++){
    //   if(i == 0){
    //     canvas.drawLine(center, startingP2, paint);
    //     canvas.drawLine(center, endingP2, paint);
    //   }else{
    //     startingP2 = endingP2;
    //     double currentAngle = eachAngle * (i+1);
    //     endingP2 = Offset(rect.size.width + math.pi * math.cos(degToRad(currentAngle)), heightCenter + math.pi * math.sin(degToRad(currentAngle)));
    //     canvas.drawLine(center, Offset(rect.size.width, heightCenter - (90-eachAngle)+heightCenter/2), paint);
    //   }
    // }
   
    // print(center);
  }
}
