import 'package:flutter/material.dart';
import 'package:fyp/models/place/district.dart';
import 'package:fyp/models/post/post_settlement_type.dart';
import 'package:fyp/models/post/post_tag.dart';
import 'package:fyp/screens/post/post_item_screen.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_dropdown_bar.dart';
import 'package:fyp/widgets/common/common_tags.dart';

// ignore: must_be_immutable
class PostItemStepThreeScreen extends StatefulWidget {
  String? selectedSettlementType;
  String? selectedDistrict;
  List<PostSettlementType> settlementTypes;
  List<PostTag> tags;
  // TextEditingController placeTextController;
  List<District> districts;
  bool submitLoading;
  bool showSelectPlace;
  bool edit;
  PostItemStepThreeScreen({
    Key? key,
    required this.selectedSettlementType,
    required this.selectedDistrict,
    required this.settlementTypes,
    required this.tags,
    required this.districts,
    required this.submitLoading,
    this.showSelectPlace = false,
    this.edit = false,
  }) : super(key: key);

  @override
  State<PostItemStepThreeScreen> createState() =>
      _PostItemStepThreeScreenState();
}

class _PostItemStepThreeScreenState extends State<PostItemStepThreeScreen>
    with TickerProviderStateMixin {
  TextEditingController placeTextController = TextEditingController();
  String place = "";
  double originalBottomSheetHeight = 300;
  double bottomSheetHeight = 300;
  bool selectPlace = false;
  bool isDragDown = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> _animation =
      Tween(begin: 0.0, end: 1.0).animate(_controller);

  bool selectedSettlementTypeErorr = false;
  bool placeError = false;
  bool tagError = false;
  String selectedSettlementTypeErrorMessage = "";
  String placeErrorMessage = "";
  String tagErrorMessage = "";

  bool _hasEmptyInput() {
    if (widget.selectedSettlementType == null) {
      selectedSettlementTypeErorr = true;
      selectedSettlementTypeErrorMessage = "Cannot be empty";
    } else {
      selectedSettlementTypeErorr = false;
      selectedSettlementTypeErrorMessage = "";
    }
    if (widget.selectedSettlementType != null &&
        widget.settlementTypes
                .map((e) => e.name)
                .toList()
                .indexOf(widget.selectedSettlementType!) ==
            1 &&
        widget.districts
            .where((element) => element.selected)
            .toList()
            .isEmpty) {
      placeError = true;
      placeErrorMessage = "Please select at least one of the place";
    } else {
      placeError = false;
      placeErrorMessage = "";
    }

    if (widget.tags.where((element) => element.selected).toList().isEmpty) {
      tagError = true;
      tagErrorMessage = "Please select at least one tag for this item";
    } else {
      tagError = false;
      tagErrorMessage = "";
    }

    // if(widget.types.isEmpty){

    // }
    // print(placeError.toString());
    return selectedSettlementTypeErorr || placeError || tagError;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectPlace = widget.showSelectPlace;
    if (selectPlace) {
      _controller.forward();
      place = widget.districts
          .where((element) => element.selected)
          .map((e) => e.name)
          .join(', ');
      placeTextController.text = place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return GestureDetector(
      child: CustomScrollView(
        slivers: [
          _buildSettlementType(),
          _buildSettlementPlace(width, height),
          _buildTags(width, height),
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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                            PostItemScreen.toSecondStepScreen(context);
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
                            'Finish',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (!_hasEmptyInput()) {
                              Utils.getInstance().showLoadingDialog(context);
                              if (widget.edit) {
                                PostItemScreen.edigtPost(context);
                              } else {
                                PostItemScreen.submitPost(context);
                              }
                            } else {
                              print('hi');
                            }
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
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildSettlementType() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type of settlement*',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CommonDropDownBar(
              value: widget.selectedSettlementType,
              items: widget.settlementTypes.map((e) => e.name).toList(),
              onChange: (value) {
                setState(() {
                  widget.selectedSettlementType = value!;
                  PostItemScreen.updateSettlementSelectedType(
                      context, widget.selectedSettlementType!);
                  if (widget.settlementTypes
                          .map((e) => e.name)
                          .toList()
                          .indexOf(value) ==
                      1) {
                    selectPlace = true;
                    _controller.forward();
                  } else {
                    selectPlace = false;
                    _controller.reverse();
                  }
                });
              },
              error: selectedSettlementTypeErorr,
              errorMessage: selectedSettlementTypeErrorMessage,
              hint: 'Select',
              textAtEnd: false,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementPlace(double width, double height) {
    return SliverToBoxAdapter(
        child: selectPlace
            ? FadeTransition(
                opacity: _animation,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferred Places*',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      placeError
                          ? Text(
                              placeErrorMessage,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      // TextFormField(
                      //   controller: widget.placeTextController,
                      //   autocorrect: false,
                      //   style: const TextStyle(
                      //       fontSize: 16, fontWeight: FontWeight.bold),
                      //   decoration: const InputDecoration(
                      //     isDense: true,
                      //     contentPadding: EdgeInsets.only(top: 20, bottom: 3),
                      //   ),
                      // ),
                      // CommonDropDownBar(
                      //     value: widget.selectedDistrict,
                      //     hint: 'select',
                      //     items: widget.districts.map((e) => e.name).toList(),
                      //     onChange: (value) {
                      //       setState(() {
                      //         widget.selectedDistrict = value;
                      //       });
                      //     }),
                      // TextFormField(
                      //   controller: placeTextController,
                      //   keyboardType: TextInputType.multiline,
                      //   readOnly: false,
                      //   decoration: const InputDecoration(
                      //     isDense: true,
                      //   ),
                      //   onTap: () async {
                      //     await _buildselectTagsBottomSheet(
                      //         width, height, widget.districts,controller: placeTextController);
                      //   },

                      // ),
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(place),
                        ),
                        onTap: () async {
                          await _buildselectTagsBottomSheet(
                              width, height, widget.districts,
                              controller: placeTextController);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              )
            : Container());
  }

  Widget _buildTags(double width, double height) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Adding some tags*',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Icon(
                    Icons.add,
                    size: 18,
                  ),
                  onTap: () async {
                    await _buildselectTagsBottomSheet(
                        width, height, widget.tags);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                // InkWell(
                //   splashColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   child: const Icon(
                //     Icons.create,
                //     size: 18,
                //   ),
                //   onTap: () async {
                //     await _buildselectTagsBottomSheet(
                //         width, height, widget.tags);
                //   },
                // ),
              ],
            ),
            tagError
                ? Text(
                    tagErrorMessage,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 10,
              children: widget.tags.map((value) {
                return value.selected
                    ? Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: CommonTags(
                            name: value.name,
                            onTap: () async {
                              setState(() {
                                value.selected = false;
                              });
                              print(
                                  widget.tags.map((e) => e.selected).toList());
                            }),
                      )
                    : Container();
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildselectTagsBottomSheet(
      double width, double height, List<dynamic> list,
      {TextEditingController? controller}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, StateSetter localState) {
        return DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  Container(
                    height: 10,
                    margin: EdgeInsets.only(
                        left: width / 2 - 50, right: width / 2 - 50),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[600],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            title: Text(list[index].name),
                            value: list[index].selected,
                            onChanged: (bool? value) {
                              localState(() {
                                list[index].selected = value!;
                                if (controller != null && value) {
                                  if (controller.text.isEmpty) {
                                    controller.text += list[index].name;
                                  } else {
                                    controller.text += ', ' + list[index].name;
                                  }
                                  place = controller.text;
                                } else if (controller != null && !value) {
                                  controller.text = list
                                      .where((element) => element.selected)
                                      .map((e) => e.name)
                                      .join(', ');
                                  place = controller.text;
                                }
                              });
                              setState(() {});
                            },
                          );
                        }),
                  ),
                ],
              );
              // onVerticalDragUpdate: (details) {
              //   int sensitivity = 5;
              //   if (details.delta.dy > sensitivity) {
              //     isDragDown = true;
              //   } else if (details.delta.dy < -sensitivity) {
              //     debugPrint('up');
              //     localState(() {
              //       bottomSheetHeight = height;
              //     });
              //   }
              // },
              // onVerticalDragEnd: (details) {
              //   if (isDragDown) {
              //     if (bottomSheetHeight == originalBottomSheetHeight) {
              //       isDragDown = false;
              //       Navigator.pop(context);
              //     } else {
              //       isDragDown = false;
              //       localState(() {
              //         bottomSheetHeight = originalBottomSheetHeight;
              //       });
              //     }
              //   }
              // },
            });
      }),
    );
  }
}
