
import 'package:flutter/material.dart';
import 'package:fyp/widgets/item/surprise_item_imageslider.dart';

class DetailItemDialog extends StatefulWidget {
  final String id;
  final String url;

  DetailItemDialog({
    required this.id,
    required this.url,
  });

  var imageURLS = [
    'https://images.pexels.com/photos/1001682/pexels-photo-1001682.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/1802268/pexels-photo-1802268.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/4886378/pexels-photo-4886378.jpeg?auto=compress&cs=tinysrgb&dprv=2&w=500',
    'https://images.pexels.com/photos/2438798/pexels-photo-2438798.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/815996/pexels-photo-815996.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  ];

  @override
  _DetailItemDialogState createState() => _DetailItemDialogState();
}

class _DetailItemDialogState extends State<DetailItemDialog> {
  double beginX = 0;
  double endX = 0;

  void _determineLikeOrDislike(DragEndDetails details) {
    if (endX < beginX) {
      print('left');
      Navigator.pop(context);
    } else if (endX > beginX) {
      print('right');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      //onPanUpdate: (details) => detectGuesture(details),
      onPanStart: (details) => {
        setState(() {
          beginX = details.localPosition.dx;
          print('start');
        })
      },
      onPanUpdate: (details) => {
        setState(() {
          endX = details.localPosition.dx;
        })
      },
      onPanEnd: (details) => _determineLikeOrDislike(details),
      child: Container(
        height: height,
        child: Card(
          margin: EdgeInsets.all(20),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.4,
                child: SurpriseItemImageSlider(widget.imageURLS.toList(),0),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text('phone'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
