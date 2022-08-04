import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/message/message_room.dart';
import 'package:fyp/screens/message/message_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

class TotalPostMessageRoomScreen extends StatefulWidget {
  const TotalPostMessageRoomScreen({Key? key}) : super(key: key);

  @override
  State<TotalPostMessageRoomScreen> createState() =>
      _TotalPostMessageRoomScreenState();
}

class _TotalPostMessageRoomScreenState
    extends State<TotalPostMessageRoomScreen> {
  List<MessageRoom> messageRooms = [];
  bool _isLoading = true;
  int userID = -1;

  void getTotalRooms() async {
    userID = await UserInfo.getUserID();
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/message/get-message-room-by-user/$userID");
    if (response!['status'] == 1) {
      for (var messageRoomJson in response['result']) {
        MessageRoom messageRoom = MessageRoom.fromJson(messageRoomJson);
        messageRooms.add(messageRoom);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        leadingWidget: InkWell(
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        title: '',
        trailingWidgets: const [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : messageRooms.isEmpty
              ? const Center(child: Text('No meesage has been found'))
              : ListView.builder(
                  itemCount: messageRooms.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    messageRooms[index].name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Text(
                                  messageRooms[index].time,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              messageRooms[index].lastMessageUserID == userID
                                  ? "You: " + messageRooms[index].latestMessage
                                  : messageRooms[index].latestMessage,
                              maxLines: 2,
                              style: const TextStyle(
                                height: 1.8,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(
                              thickness: 0.5,
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                        int userID = await UserInfo.getUserID();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageScreen(
                              creatorID: userID,
                              receiverID: userID == messageRooms[index].receiver
                                  ? messageRooms[index].creator
                                  : messageRooms[index].receiver,
                              postID: messageRooms[index].postID,
                              roomID: messageRooms[index].id,
                              viewFromRoomMessage: true,
                              receiverName: messageRooms[index].name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
