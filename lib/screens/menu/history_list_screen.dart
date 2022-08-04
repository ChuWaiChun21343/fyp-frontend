import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/detail/item_detail_screen.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({Key? key}) : super(key: key);

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  bool _isLoading = true;
  int currentPageNumber = 1;
  List<PostArticle> posts = [];

  bool _loadingError = false;
  String _errorMessage = "";

  Future<void> _getHistoryList() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response = await ApiManager.getInstance()
          .get("/post/get-all-history-post/$userID/$currentPageNumber");

      if (response!['status'] == 1) {
        for (var postJson in response['result']) {
          PostArticle postArticle = PostArticle.fromJson(postJson);
          posts.add(postArticle);
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

  Future<void> likePostOrRemoveLiked(int index) async {
    int userID = await UserInfo.getUserID();
    var formDataMap = {
      'post_id': posts[index].id,
      'user_id': userID,
    };
    if (posts[index].isLiked == 0) {
      setState(() {
        posts[index].isLiked = 1;
      });
      ApiManager.getInstance()
          .post("/post/save-liked-record", formDataMap: formDataMap);
    } else {
      setState(() {
        posts[index].isLiked = 0;
      });
      int postID = posts[index].id;
      ApiManager.getInstance().put(
        "/post/remove-liked-post/$userID/$postID",
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getHistoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';
    
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: CommonAppBar(
          leadingWidget: InkWell(
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
          title: '',
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

                                _getHistoryList();
                              },
                              child: const Text('Reload'))
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await _getHistoryList();
                    },
                    child: posts.isEmpty
                        ? const Center(
                            child: Text('No history record has been found.'))
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'History Record',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  posts.length.toString() + " items viewed",
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
                                        return _buildItem(index);
                                      }),
                                ),
                                // _buildItem(0),
                              ],
                            ),
                          ),
                  ),
      ),
    );
  }

  Widget _buildItem(int index) {
    double itemHeight = 220;
    return SizedBox(
      height: itemHeight,
      width: double.infinity,
      child: InkWell(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: itemHeight / 2 - 15 + 20,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: 'history_list${posts[index].id}',
                    child: Image.network(
                      posts[index].images![0],
                      fit: (posts[index].imagesSize.isNotEmpty &&
                              (posts[index].imagesSize[0][0] < 300 ||
                                  posts[index].imagesSize[0][1] < 300))
                          ? BoxFit.contain
                          : BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                height: itemHeight / 2 - 15 - 20,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(posts[index].name),
                          const Spacer(),
                          Row(
                            children: [
                              Text(posts[index].posterName),
                              const SizedBox(
                                width: 5,
                              ),
                              const Center(
                                child: Icon(Icons.fiber_manual_record,
                                    color: Colors.black38, size: 6),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(posts[index].lastActionTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
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
                                  height: 200,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      posts[index].isLiked == 0
                                          ? _buildBottomSheetItem('Like Item',
                                              () async {
                                              likePostOrRemoveLiked(index);
                                            })
                                          : _buildBottomSheetItem('Remove Item',
                                              () {
                                              likePostOrRemoveLiked(index);
                                            }),
                                      _buildBottomSheetItem('Message to User',
                                          () async {
                                        int userID = await UserInfo.getUserID();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MessageScreen(
                                              creatorID: userID,
                                              receiverID: posts[index].posterID,
                                              postID: posts[index].id,
                                              receiverName:
                                                  posts[index].posterName,
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
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(
                        mainImage: Image.network(
                          posts[index].images![0],
                          fit: BoxFit.fill,
                        ),
                        heroTag: 'history_list${posts[index].id}',
                        post: posts[index],
                      )));
        },
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
