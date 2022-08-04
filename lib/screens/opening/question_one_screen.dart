import 'package:flutter/material.dart';
import 'package:fyp/models/question/question.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/widgets/question/question_button.dart';
import 'package:fyp/widgets/question/question_dots.dart';

class QuestionOneScreen extends StatefulWidget {
  final Question question;
  const QuestionOneScreen({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionOneScreen> createState() => _QuestionOneScreenState();
}

class _QuestionOneScreenState extends State<QuestionOneScreen> {
  final int _PAGEINDEX = 0;

  void _checking(){
    // if(widget.question.selected == Null){

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        children: [
          const Text(
            'What kind’s of things you are looking for',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          _buildQuestions(),
          const Spacer(),
          _buildBottomInformation(),
        ],
      ),
    );
  }

  Widget _buildQuestions() {
    return Column(
      children: [
        _buildQuestion('Giving out Product', 0),
        const SizedBox(
          height: 20,
        ),
        _buildQuestion('Looking for Product', 1),
        const SizedBox(
          height: 20,
        ),
        _buildQuestion('Just Viewing the Apps', 2),
        const SizedBox(
          height: 20,
        ),
        _buildQuestion('Others', 3),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildQuestion(String title, int index) {
    Color commonSideColor = const Color(0xFFCCC8C8);
    Color selectedColor = const Color(0XFFB9B6FF);
    Color notSelectedColor = const Color(0xFF5566FF);
    BorderSide commonBorderSide = BorderSide(color: commonSideColor);
    double boxHeight = 80;
    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        border: Border(
          right: commonBorderSide,
          bottom: commonBorderSide,
          top: commonBorderSide,
          left: BorderSide(
            color: notSelectedColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: boxHeight,
            width: 15,
            decoration: BoxDecoration(color: notSelectedColor),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              height: boxHeight,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: widget.question.selected == index
                      ? selectedColor
                      : Colors.white),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  setState(() {
                    widget.question.selected = index;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomInformation() {
    return Row(
      children: [
        QuestionDot(index: 0, pageIndex: _PAGEINDEX),
        QuestionDot(index: 1, pageIndex: _PAGEINDEX),
        QuestionDot(index: 2, pageIndex: _PAGEINDEX),
        const Spacer(),
        QuestionButton(
            title: 'Next',
            onTap: () {
              QuestionScreen.toQuestionTwoScreen(context);
            }),
      ],
    );
  }
}
