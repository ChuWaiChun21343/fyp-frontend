import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/detail/item_detail_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

class ReceiveItemListScreen extends StatefulWidget {
  const ReceiveItemListScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveItemListScreen> createState() => _ReceiveItemListScreenState();
}

class _ReceiveItemListScreenState extends State<ReceiveItemListScreen> {
  bool _isLoading = true;
  bool _loadingError = false;
  String _errorMessage = "";
  List<PostArticle> posts = [];
  Future<void> _getTransferredItemList() async {
    AppLocalizations localization = AppLocalizations.of(context)!;
    try {
      int userID = await UserInfo.getUserID();
      Map<String, dynamic>? response = await ApiManager.getInstance()
          .get("/post/get-all-transferred-post/$userID");

      if (response!['status'] == 1) {
        for (var postJson in response['result']) {
          PostArticle postArticle = PostArticle.fromJson(postJson);
          postArticle.isLiked = 1;
          posts.add(postArticle);
        }
        setState(() {
          _loadingError = false;
          _isLoading = false;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getTransferredItemList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
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
                                posts = [];
                                _getTransferredItemList();
                              },
                              child: const Text('Reload'))
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {

                      await _getTransferredItemList();
                    },
                    child: posts.isEmpty
                        ? const Center(
                            child: Text('No item has been obtained.'))
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Obtained Item Record',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  posts.length.toString() + " items obtained",
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
                    tag: 'receive_list${posts[index].id}',
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
                              Text("Obtained on "+posts[index].transferTime),
                            ],
                          ),
                        ],
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
                        heroTag: 'receive_list${posts[index].id}',
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
