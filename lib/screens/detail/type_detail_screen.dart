import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/home/notification_screen.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/item/item_container.dart';

import '../../user_info.dart';

class TypeDetailScreen extends StatefulWidget {
  final String type;
  final int typeID;
  const TypeDetailScreen({ Key? key,required this.type,required this.typeID}) : super(key: key);

  @override
  State<TypeDetailScreen> createState() => _TypeDetailScreenState();
}

class _TypeDetailScreenState extends State<TypeDetailScreen> {
  bool _isLoading = true;
  List<PostArticle> posts = [];
  int currentPageNumber = 1;

  Future<void> _getRelatedTagsPost() async {
    int userID = await UserInfo.getUserID();
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/get-all-type-post/$userID/${widget.typeID}/$currentPageNumber");
    if (response!['status'] == 1) {
      for (var postJson in response['result']) {
        PostArticle postArticle = PostArticle.fromJson(postJson);
        posts.add(postArticle);
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
    _getRelatedTagsPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.type,
        textColor: Colors.blue,
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
                Icons.notifications_none_outlined,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              },
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'Display',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Text(
                        posts.length.toString() + " items dislayed",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: posts.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ItemContainer(
                          heroTag: 'typePost_$index}',
                          post: posts[index],
                          width: 300,
                          isGrid: true,
                        );
                      }),
                ),
              ],
            ),
    );
  }
}