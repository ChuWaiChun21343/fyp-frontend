import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/global/globals.dart';
import 'package:fyp/models/place/district.dart';
import 'package:fyp/models/post/post_article.dart';
import 'package:fyp/models/post/post_settlement_type.dart';
import 'package:fyp/models/post/post_tag.dart';
import 'package:fyp/models/post/post_type.dart';
import 'package:fyp/screens/post/post_item_step_one_screen.dart';
import 'package:fyp/screens/post/post_item_step_three_screen.dart';
import 'package:fyp/screens/post/post_item_step_two_screen.dart';
import 'package:fyp/user_info.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

class PostItemScreen extends StatefulWidget {
  final bool edit;
  final PostArticle? post;
  static const routeName = '/postItem';
  const PostItemScreen({Key? key, this.edit = false, this.post})
      : super(key: key);

  static void updateSelectedType(BuildContext context, String type) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.updateSelectedType(type);
  }

  static void updateSettlementSelectedType(BuildContext context, String type) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.updateSettlementSelectedType(type);
  }

  static void toFirstStepScreen(BuildContext context) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.toFirstStepScreen();
  }

  static void toSecondStepScreen(BuildContext context) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.toSecondStepScreen();
  }

  static void toThirdStepScreen(BuildContext context) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.toThirdStepScreen();
  }

  static void submitPost(BuildContext context) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.submitPost();
  }

  static void edigtPost(BuildContext context) {
    _PostItemScreenState? state =
        context.findAncestorStateOfType<_PostItemScreenState>();
    state!.editPost();
  }

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  final PageController _pageController = PageController();
  bool _isLoading = true;
  final bool _submitLoading = false;
  final bool pinned = false;
  final bool snap = false;
  final bool floating = false;
  List<PostType> types = [];
  List<PostSettlementType> settlementTypes = [];
  List<String> images = [''];
  List<String> oImages = [''];
  List<PostTag> tags = [];
  List<Widget> pages = [];
  List<District> districts = [];
  TextEditingController itemNameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController placeTextController = TextEditingController();
  int filesNums = 0;
  int _currentIndex = 0;
  String? selectedType;
  String? selectedSettlementType;
  String? selectedDistrict;

  void updateSelectedType(type) {
    selectedType = type;
  }

  void updateSettlementSelectedType(type) {
    selectedSettlementType = type;
  }

  void toFirstStepScreen() {
    setState(() {
      _currentIndex = 0;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void toSecondStepScreen() {
    setState(() {
      _currentIndex = 1;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void toThirdStepScreen() {
    setState(() {
      _currentIndex = 2;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void submitPost() async {
    List<MultipartFile> files = [];
    for (var image in images) {
      if (image != '') {
        files.add(
          MultipartFile.fromFileSync(
            image,
          ),
        );
      }
    }
    int userID = await UserInfo.getUserID();
    var formDataMap = {
      'name': itemNameTextController.text,
      'content': descriptionTextController.text,
      'type_id': types
          .where((element) => element.name == selectedType)
          .map((e) => e.id)
          .toList()[0],
      'created_by': userID,
      'others': '',
      'tags': tags
          .map((e) {
            if (e.selected) {
              return e.id;
            }
          })
          .where((element) => element != null)
          .toList(),
      'districts': districts
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      'settlementType': settlementTypes
          .where((element) => element.name == selectedSettlementType)
          .map((e) => e.id)
          .toList()[0],
      'image': files,
    };
    await ApiManager.getInstance()
        .post("/post/add-post", formDataMap: formDataMap);
    Utils.getInstance().closeDialog(context);
    await Utils.getInstance()
        .showSuccessDialog(context, "You have submitted the post successfully");
    Navigator.pop(context);
  }

  void editPost() async {
    int userID = await UserInfo.getUserID();
    List<MultipartFile> files = [];
    for (var image in images) {
      if (image != '' &&
          !image.startsWith(ApiManager.getInstance().getImagePath())) {
        files.add(
          MultipartFile.fromFileSync(
            image,
          ),
        );
      }
    }
    List<String> deteledURL = [];
    for (var image in oImages) {
      if (!image.startsWith(ApiManager.getInstance().getImagePath())) {
      } else {
        if (images.contains(image)) {
        } else {
          deteledURL.add(image);
        }
      }
    }
    var formDataMap = {
      'name': itemNameTextController.text,
      'content': descriptionTextController.text,
      'type_id': types
          .where((element) => element.name == selectedType)
          .map((e) => e.id)
          .toList()[0],
      'others': '',
      'tags':
          tags.where((element) => element.selected).map((e) => e.id).toList(),
      'districts': districts
          .where((element) => element.selected)
          .map((e) => e.id)
          .toList(),
      'settlementType': settlementTypes
          .where((element) => element.name == selectedSettlementType)
          .map((e) => e.id)
          .toList()[0],
      'image': files,
      'deleted_image': deteledURL,
    };
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .post("/post/${widget.post!.id}/$userID", formDataMap: formDataMap);
    PostArticle? postArticle;
    if (response!['status'] == 1) {
      postArticle = PostArticle.fromJson(response['result']['post']);
    }
    Utils.getInstance().closeDialog(context);
    await Utils.getInstance()
        .showSuccessDialog(context, "You have editted the post successfully");

    Navigator.pop(context, {'changed': true, 'post': postArticle});
  }

  void _setUpPostInformation() async {
    String userLocale = await UserInfo.getUserLocale();
    int lang = Globals.supportLocales.indexOf(userLocale);
    Map<String, dynamic>? response =
        await ApiManager.getInstance().get("/post/get-post-type/$lang");
    if (response!['status'] == 1) {
      for (var typeJson in response['result']) {
        var postType = PostType.fromJson(typeJson);
        types.add(postType);
      }
    }

    response = await ApiManager.getInstance().get("/post/get-post-tag/$lang");
    if (response!['status'] == 1) {
      for (var tagJson in response['result']) {
        var postTag = PostTag.fromJson(tagJson);
        tags.add(postTag);
      }
    }
    response = await ApiManager.getInstance()
        .get("/post/get-post-settlement-type/$lang");
    if (response!['status'] == 1) {
      for (var settlementTypeJson in response['result']) {
        var postSettlementType =
            PostSettlementType.fromJson(settlementTypeJson);
        settlementTypes.add(postSettlementType);
      }
    }
    response = await ApiManager.getInstance().get("/place/district/$lang");
    if (response!['status'] == 1) {
      for (var districtJson in response['result']) {
        var districtObject = District.fromJson(districtJson);
        districts.add(districtObject);
      }
    }
    if (widget.edit) {
      initializeValue();
    }

    pages = [
      PostItemScreenStepOne(
          selectedType: selectedType,
          filesNums: filesNums,
          images: images,
          types: types),
      PostItemStepTwoScreen(
        itemNameTexrController: itemNameTextController,
        descriptionTextController: descriptionTextController,
      ),
      PostItemStepThreeScreen(
        selectedSettlementType: selectedSettlementType,
        selectedDistrict: selectedDistrict,
        settlementTypes: settlementTypes,
        districts: districts,
        tags: tags,
        submitLoading: _submitLoading,
        showSelectPlace:
            (widget.edit && widget.post!.settlementType == 1) ? true : false,
        edit: widget.edit,
      ),
    ];
    setState(() {
      _isLoading = false;
    });
  }

  void initializeValue() {
    images = [...widget.post!.images!];
    if (images.length < 5) {
      images.add('');
    }
    oImages = [...widget.post!.images!];
    filesNums = images.length - 1;
    selectedType = widget.post!.type;
    selectedSettlementType = widget.post!.settlementName;
    itemNameTextController.text = widget.post!.name;
    descriptionTextController.text = widget.post!.content;
    selectedDistrict = widget.post!.places.join(', ');
    for (var place in widget.post!.places) {
      for (var element in districts) {
        if (element.name == place) {
          element.selected = true;
        }
      }
    }

    for (var tag in widget.post!.tags) {
      for (var element in tags) {
        if (element.name == tag) {
          element.selected = true;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setUpPostInformation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "",
        leadingWidget: InkWell(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        trailingWidgets: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: InkWell(
          //     child: const Icon(
          //       Icons.history,
          //       color: Colors.black,
          //       size: 24,
          //     ),
          //     onTap: () {},
          //   ),
          // ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: PageView(
                  controller: _pageController,
                  children: pages,
                  physics: const NeverScrollableScrollPhysics()),
            ),
    );
  }
}
