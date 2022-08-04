import 'package:flutter/material.dart';
import 'package:fyp/global/globals.dart';

// ignore: must_be_immutable
class CommonTags extends StatefulWidget {
  String name;
  Color backgroundColor;
  Color textColor;
  Color buttonColor;
  Function()? onTap;
  CommonTags({
    Key? key,
    required this.name,
    this.backgroundColor = Globals.tagBackgroundColor,
    this.textColor = Colors.white,
    this.buttonColor = Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CommonTags> createState() => _CommonTagsState();
}

class _CommonTagsState extends State<CommonTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: widget.backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 16,
              color: widget.textColor,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.cancel,
              color: widget.buttonColor,
            ),
            onTap: widget.onTap,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
