import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_recruit/models/district_data.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:teacher_recruit/widgets/select_button.dart';
import 'dart:math';

class DistrictRow extends StatelessWidget {
  final List<District> districts; // TODO: constraint 3 items
  const DistrictRow(this.districts);

  @override
  Widget build(BuildContext context) {
    int rep = 3;
    if (this.districts.length < 3) {
      rep = this.districts.length;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < rep; i++) DistrictButtonWidget(this.districts[i]),
      ],
    );
  }
}

class DistrictTable extends StatefulWidget {
  @override
  _DistrictTableState createState() => _DistrictTableState();
}

class _DistrictTableState extends State<DistrictTable> {
  List<District> districts = [
    District("강남구"),
    District("강동구"),
    District("강북구"),
    District("강서구"),
    District("관악구"),
    District("광진구"),
    District("구로구"),
    District("금천구"),
    District("노원구"),
    District("도봉구"),
    District("동대문구"),
    District("동작구"),
    District("마포구"),
    District("서대문구"),
    District("서초구"),
    District("성동구"),
    District("성북구"),
    District("송파구"),
    District("양천구"),
    District("영등포구"),
    District("용산구"),
    District("은평구"),
    District("종로구"),
    District("중구"),
    District("중랑구"),
  ];

  @override
  Widget build(BuildContext context) {
    late Future<List<District>> futureDistricts =
        _getSavedDistrict(this.districts, context);

    return Container(
        child: FutureBuilder<List<District>>(
            future: futureDistricts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data![1].districtName);

                return Column(
                  children: [
                    for (int i = 0; i < districts.length - 1; i = i + 3)
                      DistrictRow(districts.sublist(
                          i, min(i + 3, districts.length - 1)))
                  ],
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }));
  }
}

Future<List<District>> _getSavedDistrict(
    List<District> districts, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedDistricts = prefs.getStringList('districts');
  print("saved Districts: $savedDistricts");
  savedDistricts ??= [];
  List<District> saved = [];

  for (int i = 0; i < districts.length; i++) {
    if (savedDistricts.contains(districts[i].districtName)) {
      districts[i].isSelected = true;
      saved.add(districts[i]);
      print("toggle ${districts[i].districtName} ${districts[i].isSelected}");
    }
  }
  Provider.of<DistrictData>(context, listen: false).setDistricts(saved);
  return districts;
}
