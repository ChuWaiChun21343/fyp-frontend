import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/helper/date_helper.dart';
import 'package:fyp/models/place/district.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/models/post/post_settlement_type.dart';
import 'package:fyp/models/post/post_tag.dart';
import 'package:fyp/models/post/post_type.dart';
import 'package:fyp/screens/detail/type_detail_screen.dart';
import 'package:fyp/screens/home/home_menu_scaffold.dart';
import 'package:fyp/screens/home/notification_screen.dart';
import 'package:fyp/screens/home/post_all_screen.dart';
import 'package:fyp/screens/home/recommend_post_screen.dart';
import 'package:fyp/screens/post/post_item_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/animate/expandable_widget.dart';
import 'package:fyp/widgets/animate/rotate_widget.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/item/item_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({Key? key}) : super(key: key);

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen>
    with TickerProviderStateMixin {
  ScrollController? _controller;
  String time = "";
  String name = "";
  bool _isLoading = true;
  int selectedIndex = 0;
  int _currentGridNumber = 10;
  int currentPageNumber = 1;
  bool _updateGrid = false;
  List<PostType> pouplarType = [];
  List<PostArticle> posts = [];
  List<PostArticle> popularPost = [];
  List<PostArticle> duplicatePost = [];
  List<PostType> types = [PostType(id: 0, name: "All", selected: true)];
  List<PostSettlementType> settlementTypes = [
    PostSettlementType(id: 0, name: 'All', selected: true)
  ];
  List<PostTag> tags = [PostTag(id: 0, name: "All", selected: true)];
  late List<Time> times = [
    Time(id: 0, name: 'All', selected: true),
    Time(id: 1, name: '1 Day ago'),
    Time(id: 2, name: '1 week Ago'),
    Time(id: 3, name: 'One Month Ago'),
  ];
  List<District> districts = [
    District(
      id: 0,
      regionID: 0,
      name: 'All',
      selected: true,
    )
  ];
  bool loadedAllTypes = false;
  bool expandPlaceCategory = true;
  bool expandPlace = false;
  bool _loadingError = false;
  String _errorMessage = "";

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _scrollToBottom() {
    _controller!.addListener(() async {
      if ((_controller!.offset >= _controller!.position.maxScrollExtent) &&
          !_updateGrid) {
        _currentGridNumber += 10;
        if (_currentGridNumber > posts.length) {
          _currentGridNumber = posts.length;
        }
        setState(() {
          _updateGrid = true;
          currentPageNumber = currentPageNumber + 1;
        });
        _getAllPostArticle();
      }
    });
  }

  Future _setUp() async {
    await _getPouplarType();
    if (!_loadingError) {
      await _getPopularArticle();
      if (!_loadingError) {
        await _getAllPostArticle();
      }
    }
  }

  Future _getAllPostArticle() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    int userID = await UserInfo.getUserID();
    try {
      Map<String, dynamic>? response = await ApiManager.getInstance()
          .get("/post/get-all-post/$userID/$currentPageNumber");
      if (response!['status'] == 1) {
        for (var postJson in response['result']['posts']) {
          PostArticle postArticle = PostArticle.fromJson(postJson);
          posts.add(postArticle);
          for (var popularPost in popularPost) {
            if (popularPost.id == postArticle.id) {
              duplicatePost.add(popularPost);
            }
          }
        }
        // print(duplicatePost);
        name = response['result']['user']['name'];
        setState(() {
          _loadingError = false;
          _isLoading = false;
          currentPageNumber++;
          _updateGrid = false;
        });
      }
    } on DioError catch (e) {
      String connectionError = localization.connectionError;
      String connectTimeoutError = localization.connectTimeoutError;
      String receiveTimeoutError = localization.receiveTimeoutError;
      String othersError = localization.otherError;

      if (e.response == null) {
        _loadingError = true;
        if (e.type == DioErrorType.connectTimeout) {
          _errorMessage = connectTimeoutError;
        } else if (e.type == DioErrorType.receiveTimeout) {
          _errorMessage = receiveTimeoutError;
        } else if (e.type == DioErrorType.other) {
          _errorMessage = othersError;
        }
      } else if (e.response!.statusCode == 400) {
        // print('error');
      }
      if (_loadingError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _getPopularArticle() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    int userID = await UserInfo.getUserID();
    try {
      Map<String, dynamic>? response =
          await ApiManager.getInstance().get("/post/get-popular-post/$userID");
      if (response!['status'] == 1) {
        for (var postJson in response['result']['posts']) {
          PostArticle postArticle = PostArticle.fromJson(postJson);
          popularPost.add(postArticle);
        }
        name = response['result']['user']['name'];
      }
    } on DioError catch (e) {
      String connectionError = localization.connectionError;
      String connectTimeoutError = localization.connectTimeoutError;
      String receiveTimeoutError = localization.receiveTimeoutError;
      String othersError = localization.otherError;

      if (e.response == null) {
        _loadingError = true;
        if (e.type == DioErrorType.connectTimeout) {
          _errorMessage = connectTimeoutError;
        } else if (e.type == DioErrorType.receiveTimeout) {
          _errorMessage = receiveTimeoutError;
        } else if (e.type == DioErrorType.other) {
          _errorMessage = othersError;
        }
      } else if (e.response!.statusCode == 400) {
        // print('error');
      }
      if (_loadingError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _getPouplarType() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      Map<String, dynamic>? response =
          await ApiManager.getInstance().get("/post/get-popular-type/1");
      pouplarType = [];
      if (response!['status'] == 1) {
        for (var typeJson in response['result']) {
          var postType = PostType.fromJson(typeJson);
          pouplarType.add(postType);
        }
      }
      _loadingError = false;
    } on DioError catch (e) {
      String connectionError = localization.connectionError;
      String connectTimeoutError = localization.connectTimeoutError;
      String receiveTimeoutError = localization.receiveTimeoutError;
      String othersError = localization.otherError;

      if (e.response == null) {
        _loadingError = true;
        if (e.type == DioErrorType.connectTimeout) {
          _errorMessage = connectTimeoutError;
        } else if (e.type == DioErrorType.receiveTimeout) {
          _errorMessage = receiveTimeoutError;
        } else if (e.type == DioErrorType.other) {
          _errorMessage = othersError;
        }
      } else if (e.response!.statusCode == 400) {
        // print('error');
      }
      if (_loadingError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _getAllTypes() async {
    types = [PostType(id: 0, name: "All", selected: true)];
    settlementTypes = [PostSettlementType(id: 0, name: 'All', selected: true)];
    tags = [PostTag(id: 0, name: "All", selected: true)];
    String userLocale = await UserInfo.getUserLocale();
    int lang = Globals.supportLocales.indexOf(userLocale);
    try {
      Map<String, dynamic>? response =
          await ApiManager.getInstance().get("/post/get-post-type/$lang");
      if (response!['status'] == 1) {
        for (var typeJson in response['result']) {
          var postType = PostType.fromJson(typeJson);
          types.add(postType);
        }
      }
      response = await ApiManager.getInstance().get("/post/get-post-tag/$lang");
      if (response!['status'] == 1) {
        for (var tagJson in response['result']) {
          var postTag = PostTag.fromJson(tagJson);
          tags.add(postTag);
        }
      }
      response = await ApiManager.getInstance()
          .get("/post/get-post-settlement-type/$lang");
      if (response!['status'] == 1) {
        for (var settlementTypeJson in response['result']) {
          var postSettlementType =
              PostSettlementType.fromJson(settlementTypeJson);
          settlementTypes.add(postSettlementType);
        }
      }
      response = await ApiManager.getInstance().get("/place/district/$lang");
      if (response!['status'] == 1) {
        for (var districtJson in response['result']) {
          var districtObject = District.fromJson(districtJson);
          districts.add(districtObject);
        }
      }
      loadedAllTypes = true;
    } on DioError catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _controller = ScrollController();
      _scrollToBottom();
      _setUp();
      time = DateHelper.getInstance()!.getTimeName();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;
    double categoryHeight = 70;
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _loadingError
            ? Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                _setUp();
                              },
                              child: const Text('Reload'))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  currentPageNumber = 1;
                  posts = [];
                  popularPost = [];
                  loadedAllTypes = false;
                  // await _getPouplarType();
                  // if (!_loadingError) {
                  //   await _getPopularArticle();
                  // }
                  // if (!_isLoading) {
                  //   await _getAllPostArticle();
                  // }
                  await _setUp();
                  time = DateHelper.getInstance()!.getTimeName();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: CommonAppBar(
                    title: "",
                    leadingWidget: InkWell(
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 24,
                      ),
                      onTap: () {
                        Provider.of<MenuController>(context, listen: false)
                            .toggle();
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
                            if (!loadedAllTypes) {
                              Utils.getInstance().showLoadingDialog(context);
                              await _getAllTypes();
                              Utils.getInstance().closeDialog(context);
                            }
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
                          onTap: () {
                            Navigator.pushNamed(
                                context, NotificationScreen.routeName);
                          },
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: CustomScrollView(
                      controller: _controller,
                      slivers: [
                        SliverAppBar(
                          leading: Container(),
                          pinned: _pinned,
                          snap: _snap,
                          floating: _floating,
                          expandedHeight: 180,
                          backgroundColor: Colors.white,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       'Good $time,\n$name',
                                  //       style: const TextStyle(fontSize: 20),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Expanded(
                                  //   child: Container(
                                  //     width: double.infinity,
                                  //     margin: const EdgeInsets.only(top: 10),
                                  //     padding: const EdgeInsets.all(5),
                                  //     child: const Text(
                                  //       'Welcome To explore different Items',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //       ),
                                  //     ),
                                  //     decoration: const BoxDecoration(
                                  //       color: Color.fromRGBO(134, 175, 255, 1),
                                  //     ),
                                  //   ),
                                  // ),

                                  const Text(
                                    'Most Popular Item Type',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[0].url),
                                            title: pouplarType[0].name,
                                            typeID: pouplarType[0].id,
                                            rightBorder: true),
                                      ),
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[1].url),
                                            title: pouplarType[1].name,
                                            typeID: pouplarType[1].id,
                                            rightBorder: true),
                                      ),
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[2].url),
                                            title: pouplarType[2].name,
                                            typeID: pouplarType[2].id,
                                            rightBorder: false),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[3].url),
                                            title: pouplarType[3].name,
                                            typeID: pouplarType[3].id,
                                            rightBorder: true),
                                      ),
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[4].url),
                                            title: pouplarType[4].name,
                                            typeID: pouplarType[4].id,
                                            rightBorder: true),
                                      ),
                                      Expanded(
                                        child: _buildInformation(
                                            height: categoryHeight,
                                            icon: Image.network(
                                                pouplarType[5].url),
                                            title: pouplarType[5].name,
                                            typeID: pouplarType[5].id,
                                            rightBorder: false),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // background: Container(),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Most Popular',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        child: const Text(
                                          'See All',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                108, 187, 235, 1),
                                            fontSize: 15,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RecommendPostScreen(
                                                  posts: popularPost,
                                                ),
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: popularPost.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 20 : 0),
                                  child: ItemContainer(
                                    heroTag: 'recommand_$index',
                                    post: popularPost[index],
                                    width: height * 0.3,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 15, 0),
                                  child: const Text(
                                    'Recent Item',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return ItemContainer(
                                heroTag: 'recent_$index}',
                                post: posts[index],
                                width: height * 0.15,
                                isGrid: true,
                                //samePost: duplicatePost.where((element) => element.id == posts[index].id).toList().isEmpty ? null : duplicatePost.where((element) => element.id == posts[index].id).toList().first ,
                              );
                            }, childCount: posts.length),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _updateGrid
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 20),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: SizedBox(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushNamed(context, PostItemScreen.routeName);
                      },
                    ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostAllScreen(
                              types: types,
                              settlementTypes: settlementTypes,
                              tags: tags,
                              times: times,
                              districts: districts,
                            ),
                          ),
                        );
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
                          ...types.map(
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
                                      for (int i = 1; i < types.length; i++) {
                                        types[i].selected = false;
                                      }
                                    } else if (types[0].selected &&
                                        e.selected) {
                                      types[0].selected = false;
                                    }
                                    bool atLeastOneExist = false;
                                    for (int i = 0;
                                        i < types.length && !atLeastOneExist;
                                        i++) {
                                      if (types[i].selected) {
                                        atLeastOneExist = true;
                                      }
                                    }
                                    if (!atLeastOneExist) {
                                      types[0].selected = true;
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
                            ...times.asMap().entries.map(
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
                                              i < times.length;
                                              i++) {
                                            if (i != selectedIndex) {
                                              times[i].selected = false;
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
                            ...settlementTypes.map(
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
                                            i < settlementTypes.length;
                                            i++) {
                                          settlementTypes[i].selected = false;
                                        }
                                      } else if (settlementTypes[0].selected &&
                                          e.selected) {
                                        settlementTypes[0].selected = false;
                                      }
                                      bool atLeastOneExist = false;
                                      for (int i = 0;
                                          i < settlementTypes.length;
                                          i++) {
                                        if (settlementTypes[i].selected) {
                                          atLeastOneExist = true;
                                        }
                                        if (settlementTypes[i].selected &&
                                            (settlementTypes[i].id == 0 ||
                                                settlementTypes[i].id == 1)) {
                                          checkNeedExpandPlaceCategory = true;
                                        }
                                      }
                                      expandPlaceCategory =
                                          checkNeedExpandPlaceCategory;
                                      expandPlace =
                                          checkNeedExpandPlaceCategory;
                                      if (!atLeastOneExist) {
                                        settlementTypes[0].selected = true;
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
                        'Tags',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: [
                          ...tags.map(
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
                                      for (int i = 1; i < tags.length; i++) {
                                        tags[i].selected = false;
                                      }
                                    } else if (tags[0].selected && e.selected) {
                                      tags[0].selected = false;
                                    }
                                    bool atLeastOneExist = false;
                                    for (int i = 0;
                                        i < tags.length && !atLeastOneExist;
                                        i++) {
                                      if (tags[i].selected) {
                                        atLeastOneExist = true;
                                      }
                                    }
                                    if (!atLeastOneExist) {
                                      tags[0].selected = true;
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
                      ExpandableWidget(
                        expand: expandPlaceCategory,
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
                                  rotate: expandPlace,
                                  child: const Icon(
                                    Icons.arrow_downward,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  localState(() {
                                    expandPlace = !expandPlace;
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
                        expand: expandPlace,
                        child: Column(
                          children: [
                            ...districts.map(
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
                                                    i < districts.length;
                                                    i++) {
                                                  districts[i].selected = false;
                                                }
                                              } else if (districts[0]
                                                      .selected &&
                                                  e.selected) {
                                                districts[0].selected = false;
                                              }
                                              bool atLeastOneExist = false;
                                              for (int i = 0;
                                                  i < districts.length &&
                                                      !atLeastOneExist;
                                                  i++) {
                                                if (districts[i].selected) {
                                                  atLeastOneExist = true;
                                                }
                                              }
                                              if (!atLeastOneExist) {
                                                districts[0].selected = true;
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
                      expandPlaceCategory
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

  Widget _buildInformation(
      {required double height,
      required Widget icon,
      required String title,
      required int typeID,
      bool rightBorder = true}) {
    return InkWell(
        child: Container(
          height: height,
          // padding: EdgeInsets.fromLTRB(5, height * 0.15, 5, height * 0.05),
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: rightBorder
              ? const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey, width: 0.2),
                  ),
                )
              : null,
          child: Column(
            children: [
              SizedBox(height: height * 0.55, child: icon),
              const SizedBox(
                height: 5,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TypeDetailScreen(
                  type: title,
                  typeID: typeID,
                ),
              ));
        });
  }
}

class Time {
  int id;
  String name;
  bool selected;

  Time({
    required this.id,
    required this.name,
    this.selected = false,
  });
}
