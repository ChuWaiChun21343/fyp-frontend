import 'package:flutter/material.dart';

class QuestionDot extends StatefulWidget {
  final int index;
  final int pageIndex;
  const QuestionDot({Key? key, required this.index,required this.pageIndex}) : super(key: key);

  @override
  State<QuestionDot> createState() => _QuestionDotState();
}

class _QuestionDotState extends State<QuestionDot> {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color.fromRGBO(59, 10, 251, 0.82);
    Color notSelectedColor = const Color.fromRGBO(190, 173, 255, 0.82);
    double selectedWidth = 70;
    double notSelectedWidth = 25;
    return Container(
      height: 15,
      width: widget.index == widget.pageIndex ? selectedWidth : notSelectedWidth,
      margin: widget.index == 0
          ? const EdgeInsets.only(left: 0)
          : const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: widget.index == widget.pageIndex ? selectedColor : notSelectedColor,
      ),
    );
  }
}
