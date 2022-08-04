import 'package:flutter/material.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/widgets/question/question_button.dart';
import 'package:fyp/widgets/question/question_dots.dart';

class QuestionThreeScreen extends StatefulWidget {
  const QuestionThreeScreen({Key? key}) : super(key: key);

  @override
  State<QuestionThreeScreen> createState() => _QuestionThreeScreenState();
}

class _QuestionThreeScreenState extends State<QuestionThreeScreen> {
  final int _PAGEINDEX = 2;
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _buildBottomInformation() {
    return Row(
      children: [
        QuestionDot(index: 0, pageIndex: _PAGEINDEX),
        QuestionDot(index: 1, pageIndex: _PAGEINDEX),
        QuestionDot(index: 2, pageIndex: _PAGEINDEX),
        const Spacer(),
        QuestionButton(
            title: 'back',
            onTap: () {
              QuestionScreen.toQuestionTwoScreen(context);
            }),
        const SizedBox(
          width: 5,
        ),
        QuestionButton(title: 'Next', onTap: () {}),
      ],
    );
  }
}
