import 'package:fyp/widgets/animate/image_slide_show.dart';
import 'package:fyp/widgets/item/surprise_item.dart';
import 'package:flutter/material.dart';

class SurpriseItemImageSlider extends StatefulWidget {
  final List<String> imageURL;
  final double marginValue;

  SurpriseItemImageSlider(this.imageURL, this.marginValue);

  @override
  _SurpriseItemImageSliderState createState() =>
      _SurpriseItemImageSliderState();
}

class _SurpriseItemImageSliderState extends State<SurpriseItemImageSlider> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;
    //print('s '+ height.toString());
    return Container(
      height: height,
      child: ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        initialPage: 0,
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
        children: widget.imageURL
            .asMap()
            .map((i, url) => MapEntry(
                  i,
                  Builder(
                    builder: (BuildContext context) {
                      return Card(
                        margin: EdgeInsets.all(widget.marginValue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SurpriseItem(
                          id: i.toString(),
                          url: url,
                          marginValue: 0,
                          show: false,
                        ),
                      );
                    },
                  ),
                ))
            .values
            .toList(),

        /// Called whenever the page in the center of the viewport changes.
        // onPageChanged: (value) {
        //   print('Page changed: $value');
        // },
        autoPlayInterval: 0, onPageChanged: (int value) {  },
      ),
    );
  }
}
