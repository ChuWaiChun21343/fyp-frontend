import 'package:flutter/widgets.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/detail/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:shimmer/shimmer.dart';

class ItemContainer extends StatefulWidget {
  final String heroTag;
  final PostArticle? post;
  final double width;
  final bool isGrid;
  final int recommendRequestID;
  final bool updateRecommendView;
  final bool shimmerLoading;
  final Function? update;

  const ItemContainer({
    Key? key,
    required this.heroTag,
    required this.post,
    required this.width,
    this.isGrid = false,
    this.recommendRequestID = -1,
    this.updateRecommendView = false,
    this.shimmerLoading = false,
    this.update,
  }) : super(key: key);

  @override
  _ItemContainerState createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  final double cardImageHeight = 0.2;
  final double cardInfoHeight = 0.3;
  final double eachCardViewHeight = 0.25;

  BorderRadius border = const BorderRadius.only(
    topLeft: Radius.circular(15),
    topRight: Radius.circular(15),
  );

  late Image _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // imageStream.
  }

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>
  //         ItemDetailScreen(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       return child;
  //     },
  //   );
  // }

  void selectItem(BuildContext context) async {
    int preivousLiked = widget.post!.isLiked;
    if (widget.updateRecommendView) {
      ApiManager.getInstance().put(
          "/post/update-recommend-post-view/${widget.recommendRequestID}/${widget.post!.id}/");
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemDetailScreen(
                  mainImage: _image,
                  heroTag: widget.heroTag,
                  post: widget.post!,
                )));
    if (preivousLiked != widget.post!.isLiked) {
      setState(() {});
    }
  }

//   Route _animationRouteToItemDeail() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => ItemDetail(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }

  Image _buildImage(String url, double height, int id) {
    // // if(!_loading)
    // //   return _image;
    // _image = new Image.network(
    //   url,
    //   fit: BoxFit.cover,
    //   width: double.infinity,
    //   height: height,
    // );
    // _image.image.resolve(new ImageConfiguration()).addListener(
    //   ImageStreamListener(
    //     (info, call) {
    //       print('Networkimage is fully loaded and saved $id');
    //       setState(() {
    //         _loading = false;
    //       });
    //     },
    //   ) ,
    // );
    // print('hi $id');

    // _image = Image.asset(
    //   'assets/images/test1.jpg',
    //   fit: BoxFit.fill,
    // );
    _image = Image.network(
      url,
      fit: BoxFit.fill,
    );
    return _image;
  }

  Future<void> likePostOrRemoveLiked() async {
    int userID = await UserInfo.getUserID();
    var formDataMap = {
      'post_id': widget.post!.id,
      'user_id': userID,
    };
    if (widget.post!.isLiked == 0) {
      setState(() {
        widget.post!.isLiked = 1;
      });
      ApiManager.getInstance()
          .post("/post/save-liked-record", formDataMap: formDataMap);
    } else {
      setState(() {
        widget.post!.isLiked = 0;
      });
      int postID = widget.post!.id;
      ApiManager.getInstance().put(
        "/post/remove-liked-post/$userID/$postID",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.shimmerLoading
        ? SizedBox(
            height: widget.isGrid ? 200 : 300,
            width: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: border,
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: (Colors.grey[300])!,
                    highlightColor: (Colors.grey[100])!,
                    child: Container(
                      height: widget.isGrid ? 90 : 160,
                      decoration: BoxDecoration(
                        borderRadius: border,
                        image: const DecorationImage(
                          image: AssetImage(
                              "assets/image/shimmer_loading_image.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: widget.isGrid ? 7 : 8,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: (Colors.grey[300])!,
                                highlightColor: (Colors.grey[100])!,
                                child: Container(
                                  height: 15,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: (Colors.grey[300])!,
                                highlightColor: (Colors.grey[100])!,
                                child: Container(
                                  height: 15,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        : InkWell(
            child: SizedBox(
              height: widget.isGrid ? 200 : 300,
              width: widget.width,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: border,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: widget.isGrid ? 90 : 160,
                      child: ClipRRect(
                        borderRadius: border,
                        child: Hero(
                          tag: widget.heroTag,
                          child: FittedBox(
                            fit: (widget.post!.imagesSize.isNotEmpty &&
                                    (widget.post!.imagesSize[0][0] < 300 ||
                                        widget.post!.imagesSize[0][1] < 300))
                                ? BoxFit.contain
                                : BoxFit.contain,
                            child: _buildImage(
                                widget.post!.images![0],
                                widget.width * cardImageHeight,
                                widget.post!.id),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: widget.isGrid ? 7 : 8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.post!.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.post!.posterName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: widget.isGrid ? 3 : 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      child: widget.post!.isLiked == 0
                                          ? const Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                            )
                                          : const Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                            ),
                                      onTap: () async {
                                        likePostOrRemoveLiked();
                                      },
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
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
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    widget.post!.isLiked == 0
                                                        ? _buildBottomSheetItem(
                                                            'Like Item',
                                                            () async {
                                                            likePostOrRemoveLiked();
                                                          })
                                                        : _buildBottomSheetItem(
                                                            'Remove Item', () {
                                                            likePostOrRemoveLiked();
                                                          }),
                                                    _buildBottomSheetItem(
                                                        'Message to User',
                                                        () async {
                                                      int userID =
                                                          await UserInfo
                                                              .getUserID();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MessageScreen(
                                                            creatorID: userID,
                                                            receiverID: widget
                                                                .post!.posterID,
                                                            postID:
                                                                widget.post!.id,
                                                            receiverName: widget
                                                                .post!
                                                                .posterName,
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
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => selectItem(context),
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
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
