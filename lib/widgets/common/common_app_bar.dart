import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget leadingWidget;
  final List<Widget> trailingWidgets;
  final Color textColor;
  final Color backgroundColor;
  
  const CommonAppBar({
    Key? key,
    required this.title,
    required this.leadingWidget,
    this.trailingWidgets = const [],
    this.textColor = Colors.white,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      leading: widget.leadingWidget,
      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(
          color: widget.textColor,
          fontSize: 16,
        ),
      ),
      actions:
          widget.trailingWidgets.isEmpty ? [] : [...widget.trailingWidgets],
    );
  }
}
