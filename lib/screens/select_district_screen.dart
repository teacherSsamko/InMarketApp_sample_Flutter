import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:teacher_recruit/screens/recruit_screen.dart';
import 'package:teacher_recruit/widgets/district_layout.dart';
import 'package:teacher_recruit/widgets/select_button.dart';

class SelectDistrictScreen extends StatelessWidget {
  // const SelectSchoolScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setDistricts() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('districts',
          Provider.of<DistrictData>(context, listen: false).districtsList);
    }

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Center(
          child: Column(
            children: [
              Text(
                "지역을 선택하세요",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              DistrictTable(),
              SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  _setDistricts();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecruitsScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: completeButtonStyle,
                child: Text(
                  "선택완료",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
