import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/models/post/post_type.dart';
import 'package:fyp/screens/post/post_item_screen.dart';
import 'package:fyp/widgets/common/common_dropdown_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class PostItemScreenStepOne extends StatefulWidget {
  String? selectedType;
  int filesNums;
  List<String> images;
  List<PostType> types;
  PostItemScreenStepOne({
    Key? key,
    required this.selectedType,
    required this.filesNums,
    required this.images,
    required this.types,
  }) : super(key: key);

  @override
  State<PostItemScreenStepOne> createState() => _PostItemScreenStepOneState();
}

class _PostItemScreenStepOneState extends State<PostItemScreenStepOne> {
  final ImagePicker _picker = ImagePicker();
  bool selectTypeErorr = false;
  bool imagesErorr = false;
  String selectTypeErrorMessage = "";
  String imagesErrorMessage = "";

  bool _hasEmptyInput() {
    if (widget.selectedType == null) {
      selectTypeErorr = true;
      selectTypeErrorMessage = "Cannot be empty";
    } else {
      selectTypeErorr = false;
      selectTypeErrorMessage = "";
    }
    if (widget.images.length == 1 && widget.images[0] == '') {
      imagesErorr = true;
      imagesErrorMessage = "Must select at least one Image";
    } else {
      imagesErorr = false;
      imagesErrorMessage = "";
    }
    // if(widget.types.isEmpty){

    // }
    return selectTypeErorr || imagesErorr;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: [
        _buildSelect(),
        SliverPadding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Text(
                  'Add at least one item photo*',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                imagesErorr
                    ? Text(
                        imagesErrorMessage,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        _buildInputImage(width / 2),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${widget.filesNums}/5',
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    bool check = _hasEmptyInput();
                    debugPrint(check.toString());
                    if (!_hasEmptyInput()) {
                      PostItemScreen.toSecondStepScreen(context);
                    } else {}
                    setState(() {});

                    // var formDataMap = {
                    //   'image': [
                    //     MultipartFile.fromFileSync(
                    //       widget.images[0],
                    //     ),
                    //     MultipartFile.fromFileSync(
                    //       widget.images[1],
                    //     ),
                    //   ]
                    // };
                    // ApiManager.getInstance()
                    //     .post('/add_post', formDataMap: formDataMap)
                    //     .then((value) {
                    //   print(value);
                    // });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelect() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What kind’s of item you would like to post to the others?*',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CommonDropDownBar(
                value: widget.selectedType,
                items: widget.types.map((e) => e.name).toList(),
                onChange: (value) {
                  debugPrint(value);
                  setState(() {
                    widget.selectedType = value!;
                    PostItemScreen.updateSelectedType(
                        context, widget.selectedType!);
                    if (selectTypeErorr) {
                      selectTypeErorr = false;
                    }
                  });
                },
                hint: 'Select',
                textAtEnd: false,
                error: selectTypeErorr,
                errorMessage: selectTypeErrorMessage),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputImage(double width) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      sliver: SliverGrid.count(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          childAspectRatio: (width / 200),
          children: widget.images
              .asMap()
              .map((index, url) => MapEntry(
                    index,
                    InkWell(
                      child: url == ""
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: DottedBorder(
                                dashPattern: const [10, 6],
                                strokeWidth: 1,
                                color: (index == 0 && imagesErorr)
                                    ? Colors.red
                                    : Globals.greyTextColor,
                                child: Container(
                                  height: 200,
                                  width: width,
                                  color: Colors.transparent,
                                  child: const Icon(
                                    Icons.add_rounded,
                                    size: 40,
                                    color: Globals.greyTextColor,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 200,
                              width: width,
                              child: Stack(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: SizedBox(
                                      child: widget.images[index].startsWith(
                                              ApiManager.getInstance()
                                                  .getImagePath())
                                          ? Image.network(
                                              widget.images[index],
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(
                                              File(widget.images[index]),
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: -2,
                                    child: InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (widget.images.length == 5) {
                                            widget.images.add('');
                                          }
                                          widget.images.removeAt(index);
                                          widget.filesNums--;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (Platform.isIOS) {
                          bool imagePermission =
                              await Permission.photos.status.isGranted;
                          if (!imagePermission) {
                            await Permission.photos.request();
                          }
                        }
                        final image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          bool addImage = widget.images[index] == "";
                          widget.images[index] = image.path.toString();
                          setState(() {
                            if (widget.filesNums != 5 && addImage) {
                              widget.filesNums++;
                            }
                            if (widget.filesNums < 5 && addImage) {
                              widget.images.add('');
                            }
                          });
                        }
                      },
                    ),
                  ))
              .values
              .toList()),
    );
  }
}
