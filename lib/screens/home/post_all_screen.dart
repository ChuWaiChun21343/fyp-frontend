import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/place/district.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/models/post/post_settlement_type.dart';
import 'package:fyp/models/post/post_tag.dart';
import 'package:fyp/models/post/post_type.dart';
import 'package:fyp/screens/home/home_content_screen.dart';
import 'package:fyp/widgets/animate/expandable_widget.dart';
import 'package:fyp/widgets/animate/rotate_widget.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/item/item_container.dart';

import '../../user_info.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostAllScreen extends StatefulWidget {
  final List<PostType> types;
  final List<PostSettlementType> settlementTypes;
  final List<PostTag> tags;
  final List<Time> times;
  final List<District> districts;
  const PostAllScreen({
    Key? key,
    required this.types,
    required this.settlementTypes,
    required this.tags,
    required this.times,
    required this.districts,
  }) : super(key: key);

  @override
  State<PostAllScreen> createState() => _PostAllScreenState();
}

class _PostAllScreenState extends State<PostAllScreen> {
  int currentPageNumber = 1;
  bool _isLoading = true;
  bool _expandPlaceCategory = true;
  bool _expandPlace = false;
  bool _showRecommendation = false;
  List<PostArticle> posts = [];
  List<PostArticle> recommendPosts = [];

  bool _loadingError = false;
  String _errorMessage = "";

  Future<void> _getAllMatchedPosts() async {
    var formDataMap = {
      'types': widget.types
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      'time': widget.times.firstWhere((element) => element.selected).id,
      'settlements': widget.settlementTypes
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      'districts': widget.districts
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      'tags': widget.tags
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
    };
    int userID = await UserInfo.getUserID();
    ApiManager.getInstance()
        .post("/post/get-post-by-criteria/$userID/$currentPageNumber",
            formDataMap: formDataMap)
        .then((result) {
      if (result!['status'] == 1) {
        posts = [];
        for (var postArticleJson in result['result']) {
          PostArticle postArticle = PostArticle.fromJson(postArticleJson);
          posts.add(postArticle);
        }
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _getRecommnedationByCriteria() async {
    int userID = await UserInfo.getUserID();

    String sType = widget.types
        .where((element) => element.selected)
        .map((e) => e.id)
        .toList()
        .join(',');
    String sSettlement = widget.settlementTypes
        .where((element) => element.selected)
        .map((e) => e.id)
        .toList()
        .join(',');
    String sPlaces = widget.districts
        .where((element) => element.selected)
        .map((e) => e.id)
        .toList()
        .join(',');
    int time = widget.times.firstWhere((element) => element.selected).id;
    String sTags = widget.tags
        .where((element) => element.selected)
        .map((e) => e.id)
        .toList()
        .join(',');
    Map<String, dynamic>? response = await ApiManager.getInstance().get(
        "/post/recommend-post-by-criteria/$userID/$sType/$sSettlement/$sPlaces/$sTags/$time");

    if (response!['status'] == 1) {
      recommendPosts = [];
      for (var postArticleJson in response['result']['recommend_posts']) {
        PostArticle postArticle = PostArticle.fromJson(postArticleJson);
        recommendPosts.add(postArticle);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllMatchedPosts();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        leadingWidget: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        trailingWidgets: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.black,
                size: 24,
              ),
              onTap: () async {
                await _buildselectBottomSheet(width, height);
              },
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {},
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : posts.isEmpty
              ? const Center(
                  child: Text(
                    'Sorry,We cannot find any items match with your requirments',
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Result',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _showRecommendation
                                    ? recommendPosts.length.toString() +
                                        " items displayed"
                                    : posts.length.toString() +
                                        " items dislayed",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 2),
                          //   child: InkWell(
                          //     child: Text(
                          //       _showRecommendation
                          //           ? 'Show matched items'
                          //           : 'Show similiar item',
                          //       style: const TextStyle(color: Colors.blue),
                          //     ),
                          //     onTap: () async {
                          //       setState(() {
                          //         _showRecommendation = true;
                          //         _isLoading = true;
                          //       });

                          //       await _getRecommnedationByCriteria();
                          //     },
                          //     highlightColor: Colors.transparent,
                          //     focusColor: Colors.transparent,
                          //     splashColor: Colors.transparent,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 0.9,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: _showRecommendation
                                ? recommendPosts.length
                                : posts.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return ItemContainer(
                                heroTag: _showRecommendation
                                    ? 'recommend_criteriaPost_$index}'
                                    : 'criteriaPost_$index}',
                                post: _showRecommendation
                                    ? recommendPosts[index]
                                    : posts[index],
                                width: 300,
                                isGrid: true,
                              );
                            }),
                      ),
                      // _buildItem(0),
                    ],
                  ),
                ),
    );
  }

  Future<void> _buildselectBottomSheet(
    double width,
    double height,
  ) async {
    double bottomSheetHeight =
        height - AppBar().preferredSize.height - kBottomNavigationBarHeight;
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
        return AnimatedContainer(
          height: bottomSheetHeight,
          duration: const Duration(milliseconds: 400),
          child: SingleChildScrollView(
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _showRecommendation = false;
                          _isLoading = true;
                        });
                        _getAllMatchedPosts();
                      },
                      child: const Text('Search'),
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Types',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: [
                          ...widget.types.map(
                            (e) => Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: InkWell(
                                child: Chip(
                                  shape: const StadiumBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 0.5)),
                                  backgroundColor:
                                      e.selected ? Colors.black : Colors.white,
                                  label: Text(
                                    e.name,
                                    style: TextStyle(
                                      color: e.selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  localState(() {
                                    e.selected = !e.selected;
                                    if (e.id == 0 && e.selected) {
                                      for (int i = 1;
                                          i < widget.types.length;
                                          i++) {
                                        widget.types[i].selected = false;
                                      }
                                    } else if (widget.types[0].selected &&
                                        e.selected) {
                                      widget.types[0].selected = false;
                                    }
                                    bool atLeastOneExist = false;
                                    for (int i = 0;
                                        i < widget.types.length &&
                                            !atLeastOneExist;
                                        i++) {
                                      if (widget.types[i].selected) {
                                        atLeastOneExist = true;
                                      }
                                    }
                                    if (!atLeastOneExist) {
                                      widget.types[0].selected = true;
                                    }
                                  });
                                },
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Time',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...widget.times.asMap().entries.map(
                                  (e) => Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: InkWell(
                                      child: Chip(
                                        shape: const StadiumBorder(
                                            side: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        backgroundColor: e.value.selected
                                            ? Colors.black
                                            : Colors.white,
                                        label: Text(
                                          e.value.name,
                                          style: TextStyle(
                                            color: e.value.selected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        localState(() {
                                          if (e.value.selected) return;
                                          e.value.selected = true;
                                          int selectedIndex = e.key;
                                          for (int i = 0;
                                              i < widget.times.length;
                                              i++) {
                                            if (i != selectedIndex) {
                                              widget.times[i].selected = false;
                                            }
                                          }
                                        });
                                      },
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Settlement Type',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...widget.settlementTypes.map(
                              (e) => Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: InkWell(
                                  child: Chip(
                                    shape: const StadiumBorder(
                                        side: BorderSide(
                                            color: Colors.grey, width: 0.5)),
                                    backgroundColor: e.selected
                                        ? Colors.black
                                        : Colors.white,
                                    label: Text(
                                      e.name,
                                      style: TextStyle(
                                        color: e.selected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    bool checkNeedExpandPlaceCategory = false;
                                    localState(() {
                                      e.selected = !e.selected;
                                      if (e.id == 0 && e.selected) {
                                        for (int i = 1;
                                            i < widget.settlementTypes.length;
                                            i++) {
                                          widget.settlementTypes[i].selected =
                                              false;
                                        }
                                      } else if (widget
                                              .settlementTypes[0].selected &&
                                          e.selected) {
                                        widget.settlementTypes[0].selected =
                                            false;
                                      }
                                      bool atLeastOneExist = false;
                                      for (int i = 0;
                                          i < widget.settlementTypes.length;
                                          i++) {
                                        if (widget
                                            .settlementTypes[i].selected) {
                                          atLeastOneExist = true;
                                        }
                                        if (widget
                                                .settlementTypes[i].selected &&
                                            (widget.settlementTypes[i].id ==
                                                    0 ||
                                                widget.settlementTypes[i].id ==
                                                    1)) {
                                          checkNeedExpandPlaceCategory = true;
                                        }
                                      }
                                      _expandPlaceCategory =
                                          checkNeedExpandPlaceCategory;
                                      _expandPlace =
                                          checkNeedExpandPlaceCategory;
                                      if (!atLeastOneExist) {
                                        widget.settlementTypes[0].selected =
                                            true;
                                      }
                                    });
                                  },
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ExpandableWidget(
                        expand: _expandPlaceCategory,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Place',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                child: RotateWidget(
                                  rotate: _expandPlace,
                                  child: const Icon(
                                    Icons.arrow_upward,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  localState(() {
                                    _expandPlace = !_expandPlace;
                                  });
                                },
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ExpandableWidget(
                        expand: _expandPlace,
                        child: Column(
                          children: [
                            ...widget.districts.map(
                              (e) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        e.name,
                                        style: const TextStyle(fontSize: 16),
                                      )),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Checkbox(
                                          value: e.selected,
                                          onChanged: (value) {
                                            localState(() {
                                              e.selected = value!;
                                              if (e.id == 0 && e.selected) {
                                                for (int i = 1;
                                                    i < widget.districts.length;
                                                    i++) {
                                                  widget.districts[i].selected =
                                                      false;
                                                }
                                              } else if (widget
                                                      .districts[0].selected &&
                                                  e.selected) {
                                                widget.districts[0].selected =
                                                    false;
                                              }
                                              bool atLeastOneExist = false;
                                              for (int i = 0;
                                                  i < widget.districts.length &&
                                                      !atLeastOneExist;
                                                  i++) {
                                                if (widget
                                                    .districts[i].selected) {
                                                  atLeastOneExist = true;
                                                }
                                              }
                                              if (!atLeastOneExist) {
                                                widget.districts[0].selected =
                                                    true;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _expandPlaceCategory
                          ? const Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
