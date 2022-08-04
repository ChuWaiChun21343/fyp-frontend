import 'package:flutter/material.dart';

class LoginClipPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();

    print(size.height);
    print(size.width);
    
    path.lineTo(0, size.height /2);
    var firstControlPoint = new Offset(size.width / 2, size.height / 1);
    var firstEndPoint = new Offset(size.width-(size.width / 3), size.height / 2);
    // var secondControlPoint =
    //     new Offset(size.width - (size.width / 4), size.height / 2);
    // var secondEndPoint = new Offset(size.width, size.height /2);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height /2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}