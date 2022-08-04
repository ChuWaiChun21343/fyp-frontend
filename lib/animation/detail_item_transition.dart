// import 'package:flutter/material.dart';
// import 'package:fyp/widgets/radial_expansion.dart';

// class DetailItemTransition extends StatefulWidget {
//   final Widget item;
//   DetailItemTransition({Key? key,required this.item}) : super(key: key);

//   @override
//   _DetailItemTransitionState createState() => _DetailItemTransitionState();
// }

// class _DetailItemTransitionState extends State<DetailItemTransition> {
//   RectTween _createRectTween(Rect? begin, Rect? end) {
//     return MaterialRectCenterArcTween(begin: begin, end: end);
//   }

//   //  Widget _buildPage(
//   //     BuildContext context, String imageName, String description) {
//   //   return Container(
//   //     color: Theme.of(context).canvasColor,
//   //     alignment: FractionalOffset.center,
//   //     child: SizedBox(
//   //       width: 4 * 2.0,
//   //       height: 4 * 2.0,
//   //       child: Hero(
//   //         createRectTween: _createRectTween,
//   //         tag: imageName,
//   //         child: RadialExpansion(
//   //           maxRadius: 4,
//   //           child: Photo(
//   //             photo: imageName,
//   //             onTap: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

  
//   @override
//   Widget build(BuildContext context) {
//      return SizedBox(
//       width: 4 * 2.0,
//       height: 4 * 2.0,
//       child: Hero(
//         createRectTween: _createRectTween,
//         tag: "imageName",
//         child: RadialExpansion(
//           maxRadius: 4,
//           child: (
//             photo: "imageName",
//             onTap: () {
//               Navigator.of(context).push(
//                 PageRouteBuilder<void>(
//                   pageBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation) {
//                     return AnimatedBuilder(
//                         animation: animation,
//                         builder: (BuildContext context, Widget? child) {
//                           return Opacity(
//                             opacity: Interval(0.0, 0.75, curve: Curves.fastOutSlowIn).transform(animation.value),
//                             child: widget.item,
//                           );
//                         });
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//   }

// }