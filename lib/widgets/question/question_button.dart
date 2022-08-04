import 'package:flutter/material.dart';

class QuestionButton extends StatefulWidget {
  final String title;
  final Function()? onTap;
  const QuestionButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  State<QuestionButton> createState() => _QuestionButtonState();
}

class _QuestionButtonState extends State<QuestionButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color.fromRGBO(59, 10, 251, 0.82),
        ),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
