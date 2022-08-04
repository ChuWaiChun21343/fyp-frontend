import 'package:flutter/material.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:fyp/widgets/item/item_container.dart';

class RecommendPostScreen extends StatefulWidget {
  final List<PostArticle> posts;
  const RecommendPostScreen({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  State<RecommendPostScreen> createState() => _RecommendPostScreenState();
}

class _RecommendPostScreenState extends State<RecommendPostScreen> {
  @override
  Widget build(BuildContext context) {
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
                // await _buildselectBottomSheet(width, height);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Result',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: widget.posts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return ItemContainer(
                      heroTag: 'criteriaPost_$index}',
                      post: widget.posts[index],
                      width: 300,
                      isGrid: true,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
