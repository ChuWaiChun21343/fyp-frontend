import 'package:flutter/material.dart';
import 'package:fyp/models/question/question.dart';
import 'package:fyp/screens/opening/question_one_screen.dart';
import 'package:fyp/screens/opening/question_two_screen.dart';

class QuestionScreen extends StatefulWidget {
  static const routeName = '/question';
  const QuestionScreen({Key? key}) : super(key: key);

  static void toQuestionOneScreen(BuildContext context) {
    _QuestionScreenState? state =
        context.findAncestorStateOfType<_QuestionScreenState>();
    state!.toQuestionOneScreen();
  }

  static void toQuestionTwoScreen(BuildContext context) {
    _QuestionScreenState? state =
        context.findAncestorStateOfType<_QuestionScreenState>();
    state!.toQuestionTwoScreen();
  }

  static void toQuestionThreeScreen(BuildContext context) {
    _QuestionScreenState? state =
        context.findAncestorStateOfType<_QuestionScreenState>();
    state!.toQuestionThreeScreen();
  }

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late Question question;
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  int _currentIndex = 0;

   void toQuestionOneScreen(){
    setState(() {
      _currentIndex= 0;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void toQuestionTwoScreen(){
    setState(() {
      _currentIndex= 1;
      _pageController.jumpToPage(_currentIndex);
    });
  }

   void toQuestionThreeScreen(){
    setState(() {
      _currentIndex= 2;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    question = Question();
    _pages = [
      QuestionOneScreen(question: question),
      QuestionTwoScreen(question: question)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: _pages,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics()
        ),
      ),
    );
  }
}
