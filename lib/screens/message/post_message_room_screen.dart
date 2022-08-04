import 'package:flutter/material.dart';

class PostMessageRoomScreen extends StatefulWidget {
  const PostMessageRoomScreen({Key? key}) : super(key: key);

  @override
  State<PostMessageRoomScreen> createState() => _PostMessageRoomScreenState();
}

class _PostMessageRoomScreenState extends State<PostMessageRoomScreen> {
  bool _isLoading = false;

  void getAllPostMessage() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: ListView.builder(itemBuilder: (context, index) {
              return Container();
            }),
          );
  }
}
