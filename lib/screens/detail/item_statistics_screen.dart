import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp/api/api_manger.dart';
import 'package:fyp/models/statistic/statistic.dart';
import 'package:fyp/widgets/common/common_app_bar.dart';

class ItemStatisticsScreen extends StatefulWidget {
  final int postID;
  const ItemStatisticsScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  State<ItemStatisticsScreen> createState() => _ItemStatisticsScreenState();
}

class _ItemStatisticsScreenState extends State<ItemStatisticsScreen> {
  int likedType = 1;
  int viewType = 1;
  bool _isLoading = true;
  int leftTitleMax = 5;

  List<Statistic> likedList = [];
  List<FlSpot> likedListSpot = [];
  List<Widget> likedIndicator = [];
  List<double> likedLeftIndictor = [];
  List<CheckList> likedChcekList = [
    CheckList(1, 'Last 7 days', true),
    CheckList(2, 'Last 30 days', false),
  ];
  String likeRange = 'Last 7 days';
  int likedSum = 0;
  int likedMax = 0;
  double likedX = 0;
  late int likedTitle;

  List<Statistic> viewList = [];
  List<FlSpot> viewListSpot = [];
  List<Widget> viewIndicator = [];
  List<double> viewLeftIndictor = [];
  List<CheckList> viewChcekList = [
    CheckList(1, 'Last 7 days', true),
    CheckList(2, 'Last 30 days', false),
  ];
  String viewRange = 'Last 7 days';
  int viewSum = 0;
  int viewMax = 0;
  double viewX = 0;
  late int viewTitle;

  TextStyle indicatorStyle = const TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Future<void> likedPostStatistic() async {
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/get-like-post-statistic/${widget.postID}/$likedType");

    if (response!['status'] == 1) {
      likedListSpot = [];
      likedIndicator = [];
      likedSum = 0;
      likedMax = 0;
      likedTitle = leftTitleMax;
      likedX = -1;
      double currentIndex = 0;
      for (var statisticJson in response['result']) {
        likedX++;
        Statistic statistic = Statistic.fromJson(statisticJson);
        FlSpot spot = FlSpot(currentIndex, statistic.number.toDouble());
        likedListSpot.add(spot);
        likedSum += statistic.number;
        if (statistic.number > likedMax) {
          likedMax = statistic.number;
        }
        double cycleIndex = 1;
        if (likedType != 1) {
          if (likedType == 2) {
            cycleIndex = 30 / 6;
          }
        }
        if ((currentIndex + 1) % cycleIndex == 0 || currentIndex == 0) {
          likedIndicator.add(Text(statistic.date, style: indicatorStyle));
        } else {
          likedIndicator.add(Text('', style: indicatorStyle));
        }
        currentIndex++;
      }
      likedTitle = likedMax;
      likedLeftIndictor = [0];
      if (likedMax > leftTitleMax) {
        while ((likedTitle % 5) != 0) {
          likedTitle++;
        }

        double divide = likedTitle / 5;
        double currentDivider = divide;
        for (int i = 0; i < leftTitleMax; i++) {
          likedLeftIndictor.add(currentDivider);
          currentDivider += divide;
        }
      } else {
        likedTitle = 5;
        likedLeftIndictor.add(1);
        likedLeftIndictor.add(2);
        likedLeftIndictor.add(3);
        likedLeftIndictor.add(4);
        likedLeftIndictor.add(5);
      }
    }
  }

  Future<void> viewPostStatistic() async {
    Map<String, dynamic>? response = await ApiManager.getInstance()
        .get("/post/get-view-post-statistic/${widget.postID}/$viewType");

    if (response!['status'] == 1) {
      viewListSpot = [];
      viewIndicator = [];
      viewSum = 0;
      viewMax = 0;
      viewX = -1;
      double currentIndex = 0;
      double cycleIndex = 1;
      if (viewType != 1) {
        if (viewType == 2) {
          cycleIndex = 30 / 6;
        }
      }
      for (var statisticJson in response['result']) {
        viewX++;
        Statistic statistic = Statistic.fromJson(statisticJson);
        FlSpot spot = FlSpot(currentIndex, statistic.number.toDouble());
        viewListSpot.add(spot);
        viewSum += statistic.number;
        if (statistic.number > viewMax) {
          viewMax = statistic.number;
        }
        if ((currentIndex + 1) % cycleIndex == 0 || currentIndex == 0) {
          viewIndicator.add(Text(statistic.date, style: indicatorStyle));
        } else {
          viewIndicator.add(Text('', style: indicatorStyle));
        }
        currentIndex++;
      }
      viewTitle = viewMax;
      viewLeftIndictor = [0];
      if (viewMax > leftTitleMax) {
        while ((viewTitle % 5) != 0) {
          viewTitle++;
        }

        double divide = viewTitle / 5;
        double currentDivider = divide;
        for (int i = 0; i < leftTitleMax; i++) {
          viewLeftIndictor.add(currentDivider);
          currentDivider += divide;
        }
      } else {
        viewTitle = 5;
        viewLeftIndictor.add(1);
        viewLeftIndictor.add(2);
        viewLeftIndictor.add(3);
        viewLeftIndictor.add(4);
        viewLeftIndictor.add(5);
      }
    }
  }

  Future<void> _setUpScreen() async {
    await likedPostStatistic();
    await viewPostStatistic();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _setUpScreen();
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
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            top: 10,
                            right: 5,
                          ),
                          child: Row(children: [
                            const Text(
                              'Liked Number Summary:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                                child: Text(likeRange),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          StatefulBuilder(builder: (context,
                                              StateSetter localState) {
                                            return Container(
                                                height: 200,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: likedChcekList
                                                      .map(
                                                        (e) => CheckboxListTile(
                                                            title: Text(e.name),
                                                            value: e.selected,
                                                            onChanged: (value) {
                                                              for (var checkList
                                                                  in likedChcekList) {
                                                                checkList
                                                                        .selected =
                                                                    false;
                                                              }
                                                              e.selected = true;
                                                              likeRange =
                                                                  e.name;
                                                              likedType = e.id;
                                                              if (e.id == 1) {
                                                                likedX = 6;
                                                              } else if (e.id ==
                                                                  2) {
                                                                likedX = 6;
                                                              }
                                                              localState(() {});
                                                            }),
                                                      )
                                                      .toList(),
                                                ));
                                          }));
                                  await likedPostStatistic();
                                  setState(() {});
                                }),
                          ]),
                        ),
                        SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              LineChartData(
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget:
                                            bottomLikedTitleWidgets,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 42,
                                      ),
                                    ),
                                  ),
                                  minX: 0,
                                  maxX: likedX,
                                  minY: 0,
                                  maxY: likedTitle.toDouble(),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: [...likedListSpot],
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40.0,
                          ),
                          child: SizedBox(
                            child: Text(
                              'Increased: ' + likedSum.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 40.0,
                          ),
                          child: SizedBox(
                            child: Text(
                              'Average Increased: ' +
                                  (likedSum / 7).toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 10,
                            right: 20,
                          ),
                          child: Row(children: [
                            const Text(
                              'Viewed Number Summary:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                                child: Text(viewRange),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          StatefulBuilder(builder: (context,
                                              StateSetter localState) {
                                            return Container(
                                                height: 200,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: viewChcekList
                                                      .map(
                                                        (e) => CheckboxListTile(
                                                            title: Text(e.name),
                                                            value: e.selected,
                                                            onChanged: (value) {
                                                              for (var checkList
                                                                  in viewChcekList) {
                                                                checkList
                                                                        .selected =
                                                                    false;
                                                              }
                                                              e.selected = true;
                                                              viewRange =
                                                                  e.name;
                                                              viewType = e.id;
                                                              if (e.id == 1) {
                                                                viewX = 6;
                                                              } else if (e.id ==
                                                                  2) {
                                                                viewX = 6;
                                                              }
                                                              localState(() {});
                                                            }),
                                                      )
                                                      .toList(),
                                                ));
                                          }));
                                  await viewPostStatistic();
                                  setState(() {});
                                }),
                          ]),
                        ),
                        SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget: bottomViewedTitleWidgets,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      reservedSize: 42,
                                      getTitlesWidget: leftViewTitleWidgets,
                                    ),
                                  ),
                                ),
                                minX: 0,
                                maxX: viewX,
                                minY: 0,
                                maxY: viewTitle.toDouble(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [...viewListSpot],
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40.0,
                          ),
                          child: SizedBox(
                            child: Text(
                              'Increased: ' + viewSum.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 40.0,
                          ),
                          child: SizedBox(
                            child: Text(
                              'Average Increased: ' +
                                  (viewSum / 7).toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
              ],
            ),
    );
  }

  Widget bottomLikedTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: likedIndicator[value.toInt()],
    );
  }

  Widget bottomViewedTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: viewIndicator[value.toInt()],
    );
  }

  Widget leftLikedTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    List<double> indicatorsList = [0];
    double divide = likedTitle / 5;
    double currentDivider = divide;
    if (likedMax > leftTitleMax) {
      indicatorsList.add(currentDivider);
      currentDivider += currentDivider;
    } else {
      indicatorsList.add(1);
      indicatorsList.add(2);
      indicatorsList.add(3);
      indicatorsList.add(4);
      indicatorsList.add(5);
    }
    if (indicatorsList.contains(value)) {
      return Text(value.toString(), style: style, textAlign: TextAlign.left);
    } else {
      return Container();
    }
  }

  Widget leftViewTitleWidgets(double value, TitleMeta meta) {
    String text;
    if (viewLeftIndictor.contains(value)) {
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(value.toInt().toString(), textAlign: TextAlign.right),
      );
    } else {
      return Container();
    }
  }
}

class CheckList {
  int id;
  String name;
  bool selected;

  CheckList(
    this.id,
    this.name,
    this.selected,
  );
}
