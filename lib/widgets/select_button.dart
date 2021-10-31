import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_recruit/models/district_data.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:teacher_recruit/screens/recruit_screen.dart';

class SchoolButtonWidget extends StatelessWidget {
  final String schoolName;
  const SchoolButtonWidget({this.schoolName = "초등학교"});

  @override
  Widget build(BuildContext context) {
    _setSchool() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('school',
          Provider.of<DistrictData>(context, listen: false).schoolType!);
    }

    return TextButton(
      style: schoolTypeButtonStyle,
      onPressed: () {
        print(this.schoolName);
        Provider.of<DistrictData>(context, listen: false)
            .setSchoolType(this.schoolName);
        _setSchool();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RecruitsScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      },
      child: Text(
        this.schoolName,
        style: TextStyle(fontSize: 40.0),
      ),
    );
  }
}

class SubjectButtonWidget extends StatelessWidget {
  final String subjectName;
  const SubjectButtonWidget({this.subjectName = "국어"});

  @override
  Widget build(BuildContext context) {
    _setSchool() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('school',
          Provider.of<DistrictData>(context, listen: false).schoolType!);
    }

    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        style: smallButtonStyle,
        onPressed: () {
          print(this.subjectName);
          Provider.of<DistrictData>(context, listen: false)
              .setSchoolType(this.subjectName);
          _setSchool();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => RecruitsScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        },
        child: Text(
          this.subjectName,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class DistrictButtonWidget extends StatefulWidget {
  final District schoolDistrict;
  const DistrictButtonWidget(this.schoolDistrict);

  @override
  _DistrictButtonWidgetState createState() => _DistrictButtonWidgetState();
}

class _DistrictButtonWidgetState extends State<DistrictButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // print(
    //     "${this.widget.schoolDistrict.districtName} is selected ${this.widget.schoolDistrict.isSelected}");
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        style: this.widget.schoolDistrict.isSelected
            ? districtButtonDisabledStyle
            : smallButtonStyle,
        onPressed: () {
          print(this.widget.schoolDistrict.districtName);
          if (this.widget.schoolDistrict.isSelected) {
            Provider.of<DistrictData>(context, listen: false)
                .removeDistrict(this.widget.schoolDistrict);
          } else {
            Provider.of<DistrictData>(context, listen: false)
                .addDistrict(this.widget.schoolDistrict);
          }
          print(Provider.of<DistrictData>(context, listen: false).districts);
          setState(() {
            this.widget.schoolDistrict.toggleCheck();
          });
        },
        child: Text(
          this.widget.schoolDistrict.districtName,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class OrderButtonWidget extends StatefulWidget {
  final String orderBy;
  final int idx;
  final VoidCallback stateSetter;

  const OrderButtonWidget(this.orderBy, this.idx, this.stateSetter);

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  @override
  Widget build(BuildContext context) {
    _setSort() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
          'sortBy', Provider.of<DistrictData>(context, listen: false).sortBy);
    }

    int sortIdx = Provider.of<DistrictData>(context, listen: false).sortBy;
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        style:
            sortIdx == this.widget.idx ? orderButtonStyle : orderNoButtonStyle,
        onPressed: () {
          if (sortIdx != this.widget.idx) {
            Provider.of<DistrictData>(context, listen: false)
                .changeSort(this.widget.idx);
            _setSort();
            this.widget.stateSetter();
          }
        },
        child: Text(
          this.widget.orderBy,
          style: TextStyle(
            fontSize: 16.0,
            color:
                sortIdx == this.widget.idx ? Colors.white : Color(0xFF408CFF),
          ),
        ),
      ),
    );
  }
}

class CircularAvatarButton extends StatelessWidget {
  // const CircularAvatarButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      fillColor: Colors.white,
      child: Icon(
        Icons.list,
        color: Colors.lightBlueAccent,
        size: 30.0,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

final ButtonStyle schoolTypeButtonStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  minimumSize: Size(320, 50),
  backgroundColor: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
);

final ButtonStyle smallButtonStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  minimumSize: Size(100, 42),
  backgroundColor: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
);

final ButtonStyle orderButtonStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(92.0)),
  ),
  minimumSize: Size(30, 32),
  backgroundColor: Color(0xFF408CFF),
  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
);

final ButtonStyle orderNoButtonStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(92.0)),
  ),
  minimumSize: Size(30, 32),
  backgroundColor: Color(0xFFE5E5E5),
  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
);

final ButtonStyle districtButtonDisabledStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  minimumSize: Size(100, 42),
  primary: Colors.white,
  backgroundColor: Color(0xFF408CFF),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
);

final ButtonStyle completeButtonStyle = TextButton.styleFrom(
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  backgroundColor: Color(0xFFFFDC60),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  minimumSize: Size(double.infinity, 40),
);
