import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_recruit/models/ad_helper.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:teacher_recruit/screens/select_district_screen.dart';
import 'package:teacher_recruit/screens/select_school_screen.dart';
import 'package:teacher_recruit/widgets/recruits_list.dart';
import 'package:teacher_recruit/widgets/select_button.dart';

class RecruitsScreen extends StatefulWidget {
  Map<String, int> schoolTypes = {
    '초등학교': 338,
    '중학교': 339,
    '고등학교': 340,
  };

  final List<String>? schoolDistricts;

  RecruitsScreen({this.schoolDistricts});

  @override
  _RecruitsScreenState createState() => _RecruitsScreenState();
}

class _RecruitsScreenState extends State<RecruitsScreen> {
  late Future<List<Recruit>> futureRecruits;

  @override
  void initState() {
    super.initState();
    futureRecruits = fetchRecruits();
    _getSort() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('sortBy', 0);
    }

    _getSort();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd myBanner = BannerAd(
      size: AdSize.banner,
      // adUnitId: AdManager.testBannerAdUnitId, //TODO: test
      adUnitId: AdManager.bannerAdUnitId,
      listener: BannerAdListener(),
      request: AdRequest(),
    );
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.lightBlueAccent,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (context) => SingleChildScrollView(
      //         child: Container(
      //           padding: EdgeInsets.only(
      //               bottom: MediaQuery.of(context).viewInsets.bottom),
      //           child: AddTaskScreen(),
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextButton(
                      style: smallButtonStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectSchoolScreen()));
                      },
                      child: Text("학교급"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      style: smallButtonStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectDistrictScreen()));
                      },
                      child: Text("지역"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "${context.watch<DistrictData>().schoolType} 공고",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Text(
                //   "${Provider.of<TaskData>(context).taskCount}개",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 18.0,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OrderButtonWidget("등록순", 0, refresh),
                    OrderButtonWidget("마감일순", 1, refresh),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
              ),
              child: FutureBuilder<List<Recruit>>(
                future: futureRecruits,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(child: const CircularProgressIndicator());
                  if (snapshot.hasData) {
                    // print(snapshot.data);
                    List<Recruit>? recruits = snapshot.data;
                    if (recruits!.length != 0) {
                      return RecruitsListWidget(
                        recruits: snapshot.data!,
                      );
                    } else {
                      return Center(child: Text("해당 조건에 맞는 공고가 존재하지 않습니다."));
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('${snapshot.error}');
                  }
                  return Center(child: const CircularProgressIndicator());
                },
              ),
              // child: RecruitsListWidget(),
            ),
          ),
          Container(
            width: double.infinity,
            child: adContainer,
          ),
          SizedBox(
            height: Platform.isIOS ? 34 : 0,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {
      print('refreshed');
      futureRecruits = fetchRecruits();
    });
  }
}
