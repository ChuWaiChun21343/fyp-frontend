import 'package:fyp/screens/surprise/surprise_srcreen.dart';
import 'package:fyp/widgets/item/detail_item_dialog.dart';
import 'package:flutter/material.dart';

class SurpriseItem extends StatelessWidget {
  final String id;
  final String url;
  final double marginValue;
  final bool show;

  SurpriseItem({
    required this.id,
    required this.url,
    this.marginValue = 15,
    this.show = true,
  });

  void selectItem(BuildContext context) {
    // Navigator.of(context).pushNamed(Surprise.routeName, arguments: {
    //   'id': id,
    //   'url': url,
    // });
    //Navigator.pop(context);
    // if (show)
    //   showDialog(
    //     context: context,
    //     child: DetailItemDialog(
    //       id: null,
    //       url: null,
    //     ),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectItem(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(marginValue),
      child: Container(
        padding: EdgeInsets.all(marginValue),
        child: Image.network(
          url,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(marginValue),
        ),
      ),
    );
  }
}
