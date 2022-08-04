import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/detail/item_statistics_screen.dart';
import 'package:fyp/screens/post/post_item_screen.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../user_info.dart';

class PostedListScreen extends StatefulWidget {
  const PostedListScreen({Key? key}) : super(key: key);

  @override
  State<PostedListScreen> createState() => _PostedListScreenState();
}

class _PostedListScreenState extends State<PostedListScreen> {
  bool _isLoading = true;
  int currentPageNumber = 1;
  List<PostArticle> posts = [];
  List<PostArticle> closedPosts = [];
  List<PostArticle> transferPosts = [];

  bool _loadingError = false;
  String _errorMessage = "";

  int _currentIndex = 0;

  Future<void> _getPostedList() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    posts = [];
    closedPosts = [];
    transferPosts = [];
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response = await ApiManager.getInstance()
          .get("/post/get-all-posted-post/$userID/$currentPageNumber");
      print("/post/get-all-posted-post/$userID/$currentPageNumber");
      if (response!['status'] == 1) {
        for (var postJson in response['result']) {
          PostArticle postArticle = PostArticle.fromJson(postJson);
          if (postArticle.status == 1) {
            posts.add(postArticle);
          } else if (postArticle.status == 0) {
            closedPosts.add(postArticle);
          } else if (postArticle.status == 2) {
            transferPosts.add(postArticle);
          }
        }
        setState(() {
          _loadingError = false;
          _isLoading = false;
          currentPageNumber++;
        });
      }
    } on DioError catch (e) {
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
      }
      if (_loadingError) {
        await Utils.getInstance().showErrorDialog(context, _errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateStatus(
      PostArticle post, int status, int postID, String itemName) async {
    Map<String, dynamic>? response =
        await ApiManager.getInstance().put("/post/$postID/$status");

    if (response!['status'] == 1) {
      if (status == 0) {
        notifyUser(postID, itemName, 0);
      }

      setState(() {
        post.statusName = response['result']['statusName'];
        post.status = response['result']['status'];
        Navigator.pop(context);
      });
    }
  }

  Future<void> notifyUser(int postID, String itemName, int type) async {
    ApiManager.getInstance().post("/notification/notifyUser/", formDataMap: {
      'post_id': postID,
      'user_id': -1,
      'itemName': itemName,
      'type': 0,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getPostedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: InkWell(
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            centerTitle: true,
            bottom: TabBar(
              onTap: (pos) {
                setState(() {
                  _currentIndex = pos;
                });
              },
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Public',
                    style: TextStyle(
                      color: _currentIndex == 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Closed',
                    style: TextStyle(
                      color: _currentIndex == 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Transfer',
                    style: TextStyle(
                      color: _currentIndex == 2 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _loadingError
                  ? Padding(
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

                                  _getPostedList();
                                },
                                child: const Text('Reload'))
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _getPostedList();
                      },
                      child: TabBarView(
                        children: [
                          posts.isEmpty
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                          'You haven\'t post anything.\n Create you first post now!'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              PostItemScreen.routeName);
                                        },
                                        child: const Text('Create Now'),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Posted Items',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        posts.length.toString() +
                                            " items posted",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: posts.length,
                                            itemBuilder: (_, index) {
                                              return _buildItem(
                                                  index, posts[index]);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                          closedPosts.isEmpty
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('You haven\'t close post.\n'),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Closed Items',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        closedPosts.length.toString() +
                                            " items closed",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: closedPosts.length,
                                            itemBuilder: (_, index) {
                                              return _buildItem(
                                                  index, closedPosts[index]);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                          transferPosts.isEmpty
                              ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                          'You haven\'t transfer any items.\n'),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Transferred Items',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        transferPosts.length.toString() +
                                            " items transferred",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: transferPosts.length,
                                            itemBuilder: (_, index) {
                                              return _buildItem(
                                                  index, transferPosts[index]);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, PostArticle post, {bool isTransferred = false}) {
    double itemHeight = 150;
    return InkWell(
      child: SizedBox(
        height: itemHeight,
        width: double.infinity,
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, top: 5, left: 10, right: 10),
                  child: Image.network(
                    post.images![0],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      post.name,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      post.createDate,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 7,
                                    child: Text(
                                      'Visited Number',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      post.visitedNumber.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 7,
                                    child: Text(
                                      'Liked Number',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      post.likedNumber.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //     flex: 4,
                        //     child: Container(
                        //       width: double.infinity,
                        //       padding: const EdgeInsets.all(5),
                        //       decoration: BoxDecoration(
                        //         color: post.status == 0
                        //             ? Colors.red
                        //             : Colors.green,
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       child: Text(
                        //         post.statusName,
                        //         textAlign: TextAlign.center,
                        //         style: const TextStyle(color: Colors.white),
                        //       ),
                        //     ))
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: post.status == 2 ? 100 : 230,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  (post.status == 1 || post.status == 0)
                                      ? _buildBottomSheetItem('Edit Item  ✏️ ',
                                          () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostItemScreen(
                                                edit: true,
                                                post: post,
                                              ),
                                            ),
                                          );
                                          if (result['changed']) {
                                            Navigator.pop(context);
                                            setState(() {
                                              currentPageNumber = 1;
                                              _isLoading = true;
                                            });
                                            await _getPostedList();
                                          }
                                        })
                                      : Container(),
                                  post.status == 1
                                      ? _buildBottomSheetItem('Close Item ❌',
                                          () async {
                                          await _updateStatus(
                                              post, 0, post.id, post.name);
                                          setState(() {
                                            posts.remove(post);
                                            closedPosts.add(post);
                                            closedPosts.sort(
                                                (a, b) => b.id.compareTo(a.id));
                                          });
                                        })
                                      : post.status == 0
                                          ? _buildBottomSheetItem(
                                              'Open Item ✔️', () async {
                                              await _updateStatus(
                                                  post, 1, post.id, post.name);
                                              setState(() {
                                                closedPosts.remove(post);
                                                posts.add(post);
                                                posts.sort((a, b) =>
                                                    b.id.compareTo(a.id));
                                              });
                                            })
                                          : Container(),
                                  _buildBottomSheetItem('View statistics 📊',
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ItemStatisticsScreen(
                                          postID: post.id,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
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
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(String title, Function()? onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          onTap: onTap,
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
