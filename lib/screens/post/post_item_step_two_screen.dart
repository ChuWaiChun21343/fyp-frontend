import 'package:flutter/material.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/screens/post/post_item_screen.dart';

class PostItemStepTwoScreen extends StatefulWidget {
  TextEditingController itemNameTexrController;
  TextEditingController descriptionTextController;
  PostItemStepTwoScreen(
      {Key? key,
      required this.itemNameTexrController,
      required this.descriptionTextController})
      : super(key: key);

  @override
  State<PostItemStepTwoScreen> createState() => _PostItemStepTwoScreenState();
}

class _PostItemStepTwoScreenState extends State<PostItemStepTwoScreen> {
  bool nameError = false;
  bool descriptionError = false;
  String nameErrorMessage = "";
  String descriptionErrorMessage = "";

  bool _hasEmptyInput() {
    if (widget.itemNameTexrController.text == "") {
      nameError = true;
      nameErrorMessage = "Cannot be empty";
    }
    if (widget.descriptionTextController.text == "") {
      descriptionError = true;
      descriptionErrorMessage = "Cannot be empty";
    }

    return nameError || descriptionError;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: [
        _buildInputTitle(),
        _buildInputDescription(),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: <Widget>[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          PostItemScreen.toFirstStepScreen(context);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          if (!_hasEmptyInput()) {
                            PostItemScreen.toThirdStepScreen(context);
                          } else {}
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you like to name your item?*',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                TextFormField(
                  controller: widget.itemNameTexrController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 10, bottom: 5),
                    enabledBorder: nameError
                        ? const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          )
                        : const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Globals.greyTextColor),
                          ),
                  ),
                  onChanged: (value) {
                    if (nameError && value != "") {
                      setState(() {
                        nameError = false;
                      });
                    }
                  },
                ),
                nameError
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          nameErrorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputDescription() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description of your item*',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: widget.descriptionTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              autocorrect: false,
              decoration: descriptionError
                  ? const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 10, bottom: 5),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      hintText: 'Input description',
                    )
                  : const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top: 10,
                      ),
                      hintText: 'Input description',
                    ),
              style: const TextStyle(
                height: 1.5,
              ),
              onChanged: (value) {
                if (descriptionError && value != "") {
                  setState(() {
                    descriptionError = false;
                  });
                }
              },
            ),
            descriptionError
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      descriptionErrorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
