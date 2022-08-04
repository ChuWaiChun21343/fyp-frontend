import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/screens/detail/tag_datail_screen.dart';
import 'package:fyp/screens/home/notification_screen.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/common/common_tags.dart';
import 'package:fyp/widgets/item/item_container.dart';
import 'package:shimmer/shimmer.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/itemDetail';
  final Image mainImage;
  final String heroTag;
  final PostArticle post;
  const ItemDetailScreen({
    Key? key,
    required this.mainImage,
    required this.heroTag,
    required this.post,
  }) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _isLoadingPosterItem = true;
  bool _isLoadingRecommnedationItem = true;
  int currentPageNumber = 1;
  int recommnedRequestID = -1;
  List<PostArticle> posts = [];
  List<PostArticle> recommendPosts = [];

  late ChangeNotifier changeNotifier;
  double categoryTextSize = 20;
  int _currentNumber = 0;

  CarouselController buttonCarouselController = CarouselController();

  void _saveViewRecord() async {
    int userID = await UserInfo.getUserID();
    int postID = widget.post.id;
    int posterID = widget.post.posterID;

    if (userID != posterID && widget.post.status == 1) {
      var formDataMap = {
        'post_id': postID,
        'user_id': userID,
        'start_from': DateTime.now(),
      };
      ApiManager.getInstance()
          .post("/post/save-visit-record", formDataMap: formDataMap);
    }
  }

  void _loadPosterItem() async {
    int userID = await UserInfo.getUserID();
    int posterID = widget.post.posterID;
    int postID = widget.post.id;
    //debugPrint(posterID.toString());
    Map<String, dynamic>? response = await ApiManager.getInstance().get(
        "/post/get-all-poster-posted-post/$postID/$posterID/$userID/$currentPageNumber");

    if (response!['status'] == 1) {
      for (var postJson in response['result']) {
        PostArticle postArticle = PostArticle.fromJson(postJson);
        posts.add(postArticle);
      }
    }
    setState(() {
      _isLoadingPosterItem = false;
    });
  }

  void _loadRecommendPost() async {
    int userID = await UserInfo.getUserID();
    int postID = widget.post.id;
    String itemName = widget.post.name;
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/recommend-post-by-name/$userID/$postID/$itemName");
    // print(response);
    if (response!['status'] == 1) {
      recommnedRequestID = response['result']['requst_id'];
      for (var postJson in response['result']['recommend_posts']) {
        PostArticle postArticle = PostArticle.fromJson(postJson);
        recommendPosts.add(postArticle);
      }
    }
    setState(() {
      _isLoadingRecommnedationItem = false;
    });
  }

  void _carouselChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentNumber = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _saveViewRecord();
      _loadRecommendPost();
      _loadPosterItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double bottomNavgiationBarHeight = 60;
    List<Widget> images = [];
    List<Widget> dots = [];

    for (var i = 0; i < widget.post.images!.length; i++) {
      images.add(SizedBox(
        width: double.infinity,
        child: Image.network(
          widget.post.images![i],
          fit: BoxFit.fill,
        ),
      ));
      dots.add(_buildDot(i, () {
        buttonCarouselController.animateToPage(i);
        setState(() {
          _currentNumber = i;
        });
      }));
    }
    
    return Scaffold(
      appBar: CommonAppBar(
        title: "",
        leadingWidget: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        trailingWidgets: [
          // Padding(
          //   padding: EdgeInsets.only(right: 10),
          //   child: Icon(
          //     Icons.align_vertical_center_rounded,
          //     color: Colors.black,
          //     size: 24,
          //   ),
          // ),
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.3,
              width: width,
              child: Stack(
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: GestureDetector(
                      //inkwell doesnt work in here
                      // child: widget.mainImage,
                      child: CarouselSlider(
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: double.infinity,
                          onPageChanged: _carouselChange,
                          autoPlay: false,
                        ),
                        items: images,
                      ),
                      onTap: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dots,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      fontSize: categoryTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, top: 10),
                        child: Chip(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          shape: const StadiumBorder(),
                          label: Text(
                            widget.post.type,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildInfomrations(),
                  const SizedBox(
                    height: 25,
                  ),
                  _buildDescription(widget.post.content),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildPosterAnotherItems(),
                  const SizedBox(
                    height: 30,
                  ),
                  widget.post.status == 1 ? _buildRecommedItems() : Container(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: bottomNavgiationBarHeight,
        child: Row(
          children: [
            widget.post.status != 1
                ? Container()
                : Expanded(
                    child: Container(
                      decoration:
                          const BoxDecoration(color: Colors.deepOrangeAccent),
                      height: bottomNavgiationBarHeight,
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.all(0)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () async {
                          int userID = await UserInfo.getUserID();
                          var formDataMap = {
                            'post_id': widget.post.id,
                            'user_id': userID,
                          };
                          if (widget.post.isLiked == 0) {
                            setState(() {
                              widget.post.isLiked = 1;
                            });
                            ApiManager.getInstance().post(
                                "/post/save-liked-record",
                                formDataMap: formDataMap);
                          } else {
                            setState(() {
                              widget.post.isLiked = 0;
                            });
                            int postID = widget.post.id;
                            ApiManager.getInstance().put(
                              "/post/remove-liked-post/$userID/$postID",
                            );
                          }
                        },
                        child: widget.post.isLiked == 0
                            ? const Text('Save to List')
                            : const Text('Remove From List'),
                      ),
                    ),
                  ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(color: Colors.blue),
              height: bottomNavgiationBarHeight,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(0)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.teal[50]!.withOpacity(0.1)),
                ),
                onPressed: () async {
                  int userID = await UserInfo.getUserID();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(
                        creatorID: userID,
                        receiverID: widget.post.posterID,
                        postID: widget.post.id,
                        receiverName: widget.post.posterName,
                      ),
                    ),
                  );
                },
                child: const Text('Send Message'),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildInfomrations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.person_outline_sharp,
                size: 26,
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              flex: 9,
              child: InkWell(
                child: Text(
                  widget.post.posterName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {},
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        _buildInformationItem(Icons.timelapse, widget.post.createDate),
        const SizedBox(
          height: 15,
        ),
        _buildInformationItem(Icons.merge_type, widget.post.settlementName),
        const SizedBox(
          height: 15,
        ),
        widget.post.settlementType == 1
            ? _buildInformationItem(
                Icons.location_on_outlined, widget.post.places.join(', '))
            : Container(),
        SizedBox(
          height: widget.post.settlementType == 1 ? 15 : 0,
        ),
        _buildInformationItem(Icons.sentiment_very_satisfied_rounded,
            widget.post.likedNumber.toString() + ' people found intested'),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildInformationItem(IconData iconData, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Icon(
            iconData,
            size: 26,
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 9,
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: categoryTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            content,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            // child: Text(
            //   "#" + widget.post.tags.join(', #'),
            //   textAlign: TextAlign.start,
            //   style: const TextStyle(
            //     color: Colors.blue,
            //     fontSize: 16,
            //   ),
            // ),
            child: Wrap(
                children: widget.post.tags.asMap().entries.map((e) {
              if (e.key == 0) {
                return _buildTagsInkWell(e.value, isFirst: true);
              } else {
                return _buildTagsInkWell(e.value);
              }
            }).toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterAnotherItems() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User has also posted',
            style: TextStyle(
              fontSize: categoryTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _isLoadingPosterItem
              ? Container()
              : posts.isEmpty
                  ? const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'User haven\'t post anything',
                        textAlign: TextAlign.center,
                      ))
                  : SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...posts.map((post) {
                            GlobalKey key = GlobalKey();
                            String heroTag = key.toString();
                            return SizedBox(
                              width: 200,
                              child: ItemContainer(
                                  heroTag:
                                      'obtained_$heroTag' + post.id.toString(),
                                  post: post,
                                  isGrid: true,
                                  width: 150),
                            );
                          })
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, Function() onTap) {
    return InkWell(
      child: Container(
        height: 10,
        width: 9,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: _currentNumber == index ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTagsInkWell(String tag, {isFirst = false}) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagDetailScreen(
                tag: tag,
              ),
            ),
          );
        },
        child: Text(
          isFirst ? "#" + tag : ", #" + tag,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ));
  }

  Widget _buildRecommedItems() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Another items your might like',
            style: TextStyle(
              fontSize: categoryTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: _isLoadingRecommnedationItem
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 200,
                        height: 200,
                        child: ItemContainer(
                          heroTag: "",
                          post: null,
                          width: 150,
                          isGrid: true,
                          recommendRequestID: recommnedRequestID,
                          updateRecommendView: true,
                          shimmerLoading: true,
                        ),
                      );
                    })
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...recommendPosts.map((post) {
                        GlobalKey key = GlobalKey();
                        String heroTag = key.toString();
                        return SizedBox(
                          width: 200,
                          child: ItemContainer(
                            heroTag: 'recommend_$heroTag' + post.id.toString(),
                            post: post,
                            width: 150,
                            isGrid: true,
                            recommendRequestID: recommnedRequestID,
                            updateRecommendView: true,
                            shimmerLoading: _isLoadingPosterItem,
                          ),
                        );
                      })
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
