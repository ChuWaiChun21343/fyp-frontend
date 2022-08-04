import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/models/question/question.dart';
import 'package:fyp/screens/opening/question_screen.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_dropdown_bar.dart';
import 'package:fyp/widgets/common/common_number_picker.dart';
import 'package:fyp/widgets/question/question_button.dart';
import 'package:fyp/widgets/question/question_dots.dart';

class QuestionTwoScreen extends StatefulWidget {
  final Question question;
  const QuestionTwoScreen({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionTwoScreen> createState() => _QuestionTwoScreenState();
}

class _QuestionTwoScreenState extends State<QuestionTwoScreen> {
  final int _PAGEINDEX = 1;
  String gender = 'M';
  String? occupation;
  int age = 10;
  final List<String> genders = ['M', 'F'];
  final List<String> occupations = ['All', 'Student'];
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController ageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        children: [
          const Text(
            'Tell us about yourself',
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
    double spaceSize = 35;
    return Column(
      children: [
        _buildInput('Age', ageTextController),
        SizedBox(
          height: spaceSize,
        ),
        _buildDropdown('Gender', gender, genders, (value) {
          setState(() {
            gender = value!;
          });
        }),
        SizedBox(
          height: spaceSize,
        ),
        _buildDropdown('Occupation', occupation, occupations, (value) {
          setState(() {
            occupation = value!;
          });
        }),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildInput(String title, TextEditingController controller,
      {bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
            child: TextFormField(
              controller: controller,
              autocorrect: false,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 20, bottom: 3),
              ),
              keyboardType: isNumber ? TextInputType.number : null,
              inputFormatters: isNumber
                  ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String title, String? value, List<String> items,
      Function(String?) onChange) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          CommonDropDownBar(
            backgroundColor: Colors.transparent,
            value: value,
            items: items,
            onChange: onChange,
            hint: 'Select',
            textAtEnd: false,
          ),
        ],
      ),
    );
  }

  // Widget _buildAgePicker() {
  //   return Container(
  //     padding: const EdgeInsets.only(left: 20, right: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Age',
  //           style: TextStyle(
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         // CommonNumberPicker(
  //         //     value: age,
  //         //     minValue: 1,
  //         //     maxValue: 100,
  //         //     numberOnChange: (value) {
  //         //       setState(() {
  //         //         age = value;
  //         //       });
  //         //     },
  //         //     error: false,
  //         //     errorMessage: "",
  //         //     minHeight: 30),
  //         InkWell(
  //           splashColor: Colors.transparent,
  //           highlightColor: Colors.transparent,
  //           child: Container(
  //             padding: const EdgeInsets.only(left: 15),
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   color: Colors.grey[300]!,
  //                 ),
  //               ),
  //             ),
  //             child: Row(children: [
  //               Text(
  //                 age.toString(),
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const Expanded(
  //                 child: Align(
  //                   alignment: Alignment.centerRight,
  //                   child: RotatedBox(
  //                     quarterTurns: 3,
  //                     child: Icon(
  //                       Icons.chevron_left,
  //                       color: Globals.greyTextColor,
  //                       size: 18,
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ]),
  //           ),
  //           onTap: () {
  //             Utils.getInstance().showNumberPicker(context, age, 1, 100, 1,
  //                 (value) {
  //               setState(() {
  //                 age = value;
  //                 widget.question.age = age;
  //               });
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

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
              QuestionScreen.toQuestionOneScreen(context);
            }),
        const SizedBox(
          width: 5,
        ),
        QuestionButton(title: 'Next', onTap: () {}),
      ],
    );
  }
}
