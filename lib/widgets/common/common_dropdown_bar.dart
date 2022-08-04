import 'package:flutter/material.dart';
import 'package:fyp/global/globals.dart';

class CommonDropDownBar extends StatefulWidget {
  final Color labelColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColors;
  final bool error;
  final String errorMessage;
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?)? onChange;
  final double minHeight;
  final double labelSize;
  final bool textAtEnd;

  const CommonDropDownBar({
    Key? key,
    this.labelColor = Colors.grey,
    this.textColor = Globals.greyTextColor,
    this.backgroundColor = Colors.white,
    this.borderColors = Colors.transparent,
    this.error = false,
    this.errorMessage = "",
    required this.value,
    this.hint = "",
    required this.items,
    required this.onChange,
    this.minHeight = 30,
    this.labelSize = 16,
    this.textAtEnd = false,
  }) : super(key: key);

  @override
  _CommonDropDownBarState createState() => _CommonDropDownBarState();
}

class _CommonDropDownBarState extends State<CommonDropDownBar> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
      ),
      child: Column(
        children: [
          Container(
            padding: widget.error
                ? const EdgeInsets.fromLTRB(0, 15, 0, 0)
                : const EdgeInsets.fromLTRB(0, 15, 0, 15),
            // decoration: BoxDecoration(
            //   color: widget.backgroundColor,
            //   borderRadius: BorderRadius.circular(40),
            //   border: Border.all(
            //     width: 1.5,
            //     color: !widget.error
            //         ? widget.borderColors
            //         : Globals.errorTextColor,
            //   ),
            // ),

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: DropdownButtonFormField(
                isDense: true,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                  enabledBorder: widget.error
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        )
                      : const UnderlineInputBorder(
                          borderSide: BorderSide(color: Globals.greyTextColor),
                        ),
                ),
                hint: SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.hint,
                    style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.labelSize,
                    ),
                    textAlign:
                        widget.textAtEnd ? TextAlign.end : TextAlign.start,
                  ),
                ),
                value: widget.value,
                icon: Container(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.chevron_left,
                      color: widget.error ? Colors.red : Globals.greyTextColor,
                      size: 18,
                    ),
                  ),
                ),
                onChanged: widget.onChange,
                items: widget.items
                    .map(
                      (value) => DropdownMenuItem<String>(
                        alignment: widget.textAtEnd
                            ? AlignmentDirectional.centerEnd
                            : AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 100,
                elevation: -100,
              ),
            ),
          ),
          widget.error
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    widget.errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
