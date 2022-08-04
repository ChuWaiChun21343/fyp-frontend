import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/data_structure/stack.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomerBottomNavigation extends StatefulWidget {
  const CustomerBottomNavigation({Key? key}) : super(key: key);

  @override
  _CustomerBottomNavigationState createState() =>
      _CustomerBottomNavigationState();
}

class _CustomerBottomNavigationState extends State<CustomerBottomNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  int searchFieldIcon = 1;
  int searchField = 0;
  int othersFieldIcon = 1;
  double searchFieldIconRotateStart = 0;
  double searchFieldIconRotateEnd = .25;
  double angle = 0;
  int count = 0;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchAnimationController.dispose();
  }

  void showTextField() {
    _searchAnimationController.forward(from: searchFieldIconRotateStart);
    count++;
    if (count != 1) {
      setState(() {
        // searchFieldIcon = searchFieldIcon == 1 ? 2 : 1;
        // searchField = searchField == 0 ? 5 : 0;
        // othersFieldIcon = othersFieldIcon == 1 ? 0 : 1;
        print(searchFieldIconRotateStart);
        searchFieldIconRotateStart = searchFieldIconRotateStart == 0 ? .25 : 0;
        searchFieldIconRotateEnd = searchFieldIconRotateEnd == .25 ? 0 : .25;
        _visible = _visible ? false : true;
        // print(searchFieldIconRotateStart);
      });
    } else {
      setState(() {
        _visible = false;
      });
    }
  }

  void showBottomSheet() {
    final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
    final redoList = Cstack<String>();
    final redoListPos = Cstack<int>();
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      // clipBehavior: ,
      duration: const Duration(milliseconds: 400),
      builder: (context) => Container(
        child: AnimatedList(
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            final item = items[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  setState(() {
                    items.removeAt(index);
                    redoList.push(item);
                    redoListPos.push(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$item dismissed'),
                        action: SnackBarAction(
                          textColor: Colors.yellow,
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              items.insert(redoListPos.pop(), redoList.pop());
                            });
                          },
                        ),
                      ),
                    );
                  });
                } else {
                  // setState(() {
                  //   print('hi');
                  // });

                }
              },
              background: Container(
                color: Colors.green,
                child: Icon(Icons.check),
                // width: context.size?.width ?? 0,
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Icon(Icons.cancel),
                // width: context.size?.width ?? 0,
              ),
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Row(children: [
          Expanded(
            flex: searchFieldIcon,
            child: Container(
              child: RotationTransition(
                //angle: searchFieldIconRotate,
                turns: Tween(
                        begin: searchFieldIconRotateStart,
                        end: searchFieldIconRotateEnd)
                    .animate(_searchAnimationController),
                // child: Transform.rotate(
                //   angle: angle,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: showTextField,
                ),
                //),
              ),
            ),
          ),
          // Expanded(
          //   flex: searchField,
          //   child: Container(
          //     width: searchField == 0
          //         ? 0
          //         : MediaQuery.of(context).size.width * 0.8,
          //     height: searchField == 0
          //         ? 0
          //         : MediaQuery.of(context).size.height * 0.05,
          //     child: TextFormField(
          //       autofocus: searchField == 0 ? false : true,
          //       decoration: InputDecoration(
          //         labelText: 'userName',
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            flex: othersFieldIcon,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Expanded(
              flex: othersFieldIcon,
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.star,
                    ),
                    onPressed: showBottomSheet,
                  ),
                ),
              )),
          Expanded(
            flex: othersFieldIcon,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.message,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
