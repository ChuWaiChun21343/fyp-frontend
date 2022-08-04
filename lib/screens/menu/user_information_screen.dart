import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/user/liked_user_detail.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';
import 'dart:collection';

class UserInformationScreen extends StatefulWidget {
  final int userID;
  final String userName;
  const UserInformationScreen({
    Key? key,
    required this.userID,
    required this.userName,
  }) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  bool _isLoading = true;
  List<LikedUserDetail> details = [];
  List<LikedUserDetail> transferDetails = [];
  Map<String, int> likedMap = {};
  Map<String, int> transferMap = {};
  String mostTypeName = "";
  int mostTypeNumber = 0;
  String mostTransferTypeName = "";
  int mostTransferTypeNumber = 0;

  Future<void> _setUp() async {
    await _getUserInformation();
    await _getUserTransferInformation();
  }

  Future<void> _getUserInformation() async {
    details = [];
    likedMap = {};
    int userID = await UserInfo.getUserID();
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/all-user-like-post-detail/$userID/${widget.userID}");

    if (response!['status'] == 1) {
      for (var likedUserDetailJson in response['result']) {
        LikedUserDetail detail = LikedUserDetail.fromJson(likedUserDetailJson);
        if (!likedMap.containsKey(detail.postType)) {
          likedMap[detail.postType] = 1;
        } else {
          likedMap[detail.postType] = likedMap[detail.postType]! + 1;
        }
        details.add(detail);
      }
      var sortedLiked = {};
      if (likedMap.length != 1) {
        sortedLiked = SplayTreeMap.from(
            likedMap, (a, b) => likedMap[b]!.compareTo(likedMap[a]!));
      } else {
        sortedLiked = likedMap;
      }

      mostTypeName = sortedLiked.keys.first.toString();
      mostTypeNumber = likedMap[mostTypeName.toString()]!;
    }
  }

  Future<void> _getUserTransferInformation() async {
    transferDetails = [];
    transferMap = {};
    int userID = await UserInfo.getUserID();
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/all-user-transferred-post-detail/$userID/${widget.userID}");
    if (response!['status'] == 1) {
      for (var likedUserDetailJson in response['result']) {
        LikedUserDetail detail = LikedUserDetail.fromJson(likedUserDetailJson);
        if (!transferMap.containsKey(detail.postType)) {
          transferMap[detail.postType] = 1;
        } else {
          transferMap[detail.postType] = transferMap[detail.postType]! + 1;
        }
        transferDetails.add(detail);
      }
      if (transferDetails.isNotEmpty) {
        var sortedTransferred = {};
        if (transferMap.length != 1) {
          sortedTransferred = SplayTreeMap.from(transferMap,
              (a, b) => transferMap[b]!.compareTo(transferMap[a]!));
        } else {
          sortedTransferred = transferMap;
        }

        mostTransferTypeName = sortedTransferred.keys.first.toString();
        mostTransferTypeNumber = transferMap[mostTransferTypeName.toString()]!;
        mostTransferTypeName = "";
        for (var item in sortedTransferred.entries) {
          if (item.value == mostTransferTypeNumber) {
            mostTransferTypeName += item.key + ", ";
          }

          mostTransferTypeName = mostTransferTypeName.substring(
              0, mostTransferTypeName.length - 2);
        }
      } else {
        mostTransferTypeNumber = 0;
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
      _setUp();
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Text('Total liked Number: '),
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(mostTypeNumber.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Text('Most Liked Type: '),
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(mostTypeName.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Text('Total Transferred Number: '),
                            ),
                            Expanded(
                              flex: 8,
                              child: Text(mostTransferTypeNumber.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        mostTransferTypeNumber == 0
                            ? Container()
                            : Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Text('Most Transferred Type: '),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child:
                                        Text(mostTransferTypeName.toString()),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  const SliverToBoxAdapter(
                      child: Divider(
                    thickness: .7,
                  )),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  const SliverToBoxAdapter(
                    child: Text(
                      'User liked History:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[100],
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: details.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  child: ListTile(
                                    title: Text(details[index].postName),
                                    subtitle: Text('Liked on ' +
                                        details[index].createDate),
                                    trailing: Chip(
                                      label: Text(
                                        details[index].postType,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Divider(
                                    thickness: 0.5,
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  const SliverToBoxAdapter(
                    child: Text(
                      'Transferred History:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: mostTransferTypeNumber == 0
                        ? const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                  'You haven\'t transfer any item to this user'),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            padding: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[100],
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: transferDetails.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        child: ListTile(
                                          title: Text(
                                              transferDetails[index].postName),
                                          subtitle: Text('Transferred on ' +
                                              transferDetails[index]
                                                  .createDate),
                                          trailing: Chip(
                                            label: Text(
                                              transferDetails[index].postType,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Divider(
                                          thickness: 0.5,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
