import 'package:flutter/material.dart';
import 'package:fyp/utils/utils.dart';

class CommonNumberPicker extends StatefulWidget {
  final String unit;
  final int value;
  final int minValue;
  final int maxValue;
  final int step;
  final Function(int) numberOnChange;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColors;
  final bool error;
  final String errorMessage;
  final double minHeight;
  const CommonNumberPicker({
    Key? key,
    this.unit = "",
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    required this.numberOnChange,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.borderColors = Colors.transparent,
    required this.error,
    required this.errorMessage,
    required this.minHeight,
  }) : super(key: key);

  @override
  _CommonNumberPickerState createState() => _CommonNumberPickerState();
}

class _CommonNumberPickerState extends State<CommonNumberPicker> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              width: 1.5,
              color: widget.borderColors,
            ),
          ),
          child: Row(
            children: [
              Text(
                '${widget.value.toString()}${widget.unit}',
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Utils.getInstance().showNumberPicker(
            context,
            widget.value,
            widget.minValue,
            widget.maxValue,
            widget.step,
            widget.numberOnChange,
          );
        },
      ),
    );
  }
}
