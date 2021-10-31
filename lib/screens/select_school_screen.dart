import 'package:flutter/material.dart';
import 'package:teacher_recruit/widgets/select_button.dart';
import 'dart:math';

class SelectSchoolScreen extends StatelessWidget {
  // const SelectSchoolScreen({Key key}) : super(key: key);
  List<String> subjects = [
    "국어",
    "수학",
    "사회",
    "과학",
    "음악",
    "미술",
    "체육",
    "기술",
    "가정",
    "영어",
    "정보",
    "상담",
    "스포츠",
    "기타",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Center(
          child: Column(
            children: [
              Text(
                "학교급을 선택하세요",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SchoolButtonWidget(schoolName: "유치원"),
              SizedBox(height: 20),
              SchoolButtonWidget(schoolName: "초등학교"),
              SizedBox(height: 20),
              Text(
                "중등",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < subjects.length - 1; i = i + 3)
                    SubjectRow(
                        subjects.sublist(i, min(i + 3, subjects.length - 1)))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectRow extends StatelessWidget {
  final List<String> _subjects; // TODO: constraint 3 items
  const SubjectRow(this._subjects);

  @override
  Widget build(BuildContext context) {
    int rep = 3;
    if (this._subjects.length < 3) {
      rep = this._subjects.length;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < rep; i++)
          SubjectButtonWidget(subjectName: this._subjects[i]),
      ],
    );
  }
}
