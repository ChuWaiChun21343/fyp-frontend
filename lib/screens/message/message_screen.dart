import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/message/message.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// ignore: must_be_immutable
class MessageScreen extends StatefulWidget {
  static const routeName = "/message";
  final int creatorID;
  final int receiverID;
  final int postID;
  int? roomID;
  bool viewFromRoomMessage;
  final String receiverName;
  MessageScreen({
    Key? key,
    required this.creatorID,
    required this.receiverID,
    required this.postID,
    this.roomID,
    this.viewFromRoomMessage = false,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late int userID;
  ScrollController _controller = ScrollController();
  late StreamSocket _streamSocket;
  late io.Socket _socket;
  TextEditingController inputController = TextEditingController();
  late int roomID;
  bool receive = false;
  bool _isLoading = true;
  bool openingBanner = true;

  List<Message> messages = [];
  late PostArticle postArticle;

  Future<void> _connectSocketIO() async {
    userID = await UserInfo.getUserID();
    _streamSocket = StreamSocket();
    await _getRoomID();
    await getPost();
    _socket =
        io.io(ApiManager.getInstance().getStockIOPath(), <String, dynamic>{
      "transports": ["websocket"],
      'forceNew': true,
    });

    _socket.onConnect((_) {
      debugPrint('connect');
    });
    _socket.on('receive', (data) async {
      if (data['room_id'] == roomID &&
          data['receiver'] == userID &&
          !widget.viewFromRoomMessage) {
        setState(() {
          Message message = Message(
              -1, data['receiver'], data['message'], data['create_date'], 0);
          messages.add(message);
        });
        _scrollToBottom();
        ApiManager.getInstance().post('/message/update-user-view-message',
            formDataMap: {'user_id': userID, 'room_id': roomID});
      } else if (widget.viewFromRoomMessage) {
        if (data['room_id'] == roomID && data['receiver'] == userID) {
          setState(() {
            Message message = Message(
                -1, data['receiver'], data['message'], data['create_date'], 0);
            messages.add(message);
          });
          _scrollToBottom();
          ApiManager.getInstance().post('/message/update-user-view-message',
              formDataMap: {'user_id': userID, 'room_id': roomID});
        }
      }
    });
    _socket.onDisconnect((_) => debugPrint('disconnect'));
  }

  Future<void> _getRoomID() async {
    int creator = widget.creatorID;
    int receiver = widget.receiverID;
    int postID = widget.postID;
    Map<String, dynamic>? response;
    if (widget.roomID == null) {
      response = await ApiManager.getInstance()
          .get("/message/get-post-chat-room-detail/$creator/$receiver/$postID");
    } else {
      int roomID = widget.roomID!;
      response = await ApiManager.getInstance()
          .get("/message/get-post-chat-room-detail/$roomID");
    }
    if (response!['status'] == 1) {
      roomID = response['result']['roomID'];
      for (var messageJson in response['result']['messages']) {
        Message message = Message.fromJson(messageJson);
        messages.add(message);
      }
      ApiManager.getInstance().put('/message/update-user-view-message',
          formDataMap: {'user_id': userID, 'room_id': roomID});
    }
  }

  Future<void> getPost() async {
    print(userID.toString() + " " + widget.postID.toString());
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post-by-id/$userID/${widget.postID}");
    print(response);
    if (response!['status'] == 1) {
      for (var postJson in response['result']['posts']) {
        postArticle = PostArticle.fromJson(postJson);
      }
      showBanner();
      _scrollToBottom();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> transferItem() async {
    Map<String, dynamic>? response = await ApiManager.getInstance().post(
        "/post/transfer-item",
        formDataMap: {'post_id': widget.postID, 'owner': widget.receiverID});
    if (response!['status'] == 1) {
      ApiManager.getInstance().post("/notification/notifyUser", formDataMap: {
        'post_id': widget.postID,
        'user_id': widget.receiverID,
        'itemName': postArticle.name,
        'type': 2,
      });
      await Utils.getInstance()
          .showConfrimMessage(context, response['result']['message']);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  void showBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(5),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postArticle.name,
            ),
            const SizedBox(height: 5),
            Text(
              postArticle.statusName,
              style: TextStyle(
                  color: postArticle.status == 0 ? Colors.red : Colors.green),
            ),
          ],
        ),
        leading: SizedBox(
          height: 40,
          child: Image.network(
            postArticle.images![0],
            fit: BoxFit.fill,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              openingBanner = false;
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              setState(() {});
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _connectSocketIO();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onTap: () {
                  _socket.disconnect();
                  ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                  Navigator.pop(context);
                },
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.receiverName.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: postArticle.posterID == userID ? 180 : 100,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          openingBanner
                              ? _buildBottomSheetItem('Close Banner 🪧',
                                  () async {
                                  openingBanner = false;
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentMaterialBanner();
                                  setState(() {});
                                })
                              : _buildBottomSheetItem('Open Banner 🪧', () {
                                  openingBanner = true;
                                  showBanner();
                                  setState(() {});
                                }),
                          postArticle.posterID == userID
                              ? _buildBottomSheetItem(
                                  'Transfer Item to this user and close the item 🎁',
                                  () async {
                                  await transferItem();
                                })
                              : Container()
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: Padding(
                        padding: openingBanner
                            ? const EdgeInsets.only(top: 65, bottom: 5)
                            : const EdgeInsets.only(top: 10, bottom: 5),
                        child: ListView.builder(
                          controller: _controller,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      messages[index].receiverID ==
                                              widget.receiverID
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: width * 0.7),
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      decoration: BoxDecoration(
                                        color: messages[index].receiverID ==
                                                widget.receiverID
                                            ? Colors.indigo[900]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text(
                                        messages[index].message,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: messages[index].receiverID ==
                                                  widget.receiverID
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      messages[index].receiverID ==
                                              widget.receiverID
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        messages[index].time,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextFormField(
                        controller: inputController,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (value) {
                          setState(() {
                            final now = DateTime.now();
                            String date =
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                            String displayTime = date;
                            Message newMessage = Message(
                                -1, widget.receiverID, value, displayTime, 0);
                            messages.add(newMessage);
                            var formDataMap = {
                              'room_id': roomID,
                              'creator': widget.creatorID,
                              'receiver': widget.receiverID,
                              'message': inputController.text,
                              'create_date': displayTime,
                              'post_id': widget.postID,
                            };
                            _socket.emit('message', [
                              formDataMap,
                            ]);
                            formDataMap['create_date'] = now;
                            ApiManager.getInstance().post(
                                "/message/add-post-message",
                                formDataMap: formDataMap);
                            inputController.text = "";
                          });
                          _scrollToBottom();
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Something',
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
