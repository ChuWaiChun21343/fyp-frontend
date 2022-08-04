import 'package:fyp/widgets/item/surprise_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SurpriseItemScrollView extends StatefulWidget {
  final List<String> imageURL;
  final double marginValue;

  SurpriseItemScrollView(this.imageURL, this.marginValue);

  @override
  _SurpriseItemScrollViewState createState() => _SurpriseItemScrollViewState();
}

class _SurpriseItemScrollViewState extends State<SurpriseItemScrollView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;
    //print('s '+ height.toString());
    return Container(
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.8,
          enableInfiniteScroll: false,
          viewportFraction: 1,
        ),
        items: widget.imageURL
            .asMap()
            .map((i, url) => MapEntry(
                  i,
                  Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.all(widget.marginValue),
                        child: SurpriseItem(
                          id: i.toString(),
                          url: url,
                        ),
                      );
                    },
                  ),
                ))
            .values
            .toList(),
      ),

    );
  }
}
