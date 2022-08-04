import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/user/liked_user.dart';
import 'package:fyp/screens/menu/user_information_screen.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

import '../../user_info.dart';

class UserLikedItemScreen extends StatefulWidget {
  static const routeName = '/userLikedItem';
  const UserLikedItemScreen({Key? key}) : super(key: key);

  @override
  State<UserLikedItemScreen> createState() => _UserLikedItemScreenState();
}

class _UserLikedItemScreenState extends State<UserLikedItemScreen> {
  bool _isLoading = true;
  List<LikedUser> users = [];

  Future<void> _getAllUserLike() async {
    int userID = await UserInfo.getUserID();
    users = [];
    Map<String, dynamic>? response =
        await ApiManager.getInstance().get("/post/all-user-like-post/$userID");
    if (response!['status'] == 1) {
      for (var likedUserJson in response['result']) {
        LikedUser likedUser = LikedUser.fromJson(likedUserJson);
        users.add(likedUser);
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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getAllUserLike();
    });
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(
                  child: Text('Sorry, There is no user has liked your item'))
              : ListView.builder(
                  itemCount: users.length,
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
                                    users[index].name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total liked: " +
                                  users[index].totalNumber.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "👍 Liked your Item \"" +
                                  users[index].postName +
                                  "\" on " +
                                  users[index].lastTime,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInformationScreen(
                              userID: users[index].id,
                              userName: users[index].name,
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
