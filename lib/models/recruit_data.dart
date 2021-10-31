import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_recruit/models/district_data.dart';

class DistrictData extends ChangeNotifier {
  List<District> _selectedDistrict = [];
  Map<String, int> _schoolTypes = {
    '유치원': 337,
    '초등': 338,
    '중등': 339,
  };
  Map<int, String> _schoolCodeName = {
    337: '유치원',
    338: '초등학교',
    339: '중등',
  };
  String _schoolType = '초등학교';
  int _schoolCode = 338;
  int _sortByIdx = 0;

  UnmodifiableListView get districts {
    return UnmodifiableListView(_selectedDistrict);
  }

  List<String> get districtsList {
    List<String> districtString = [];
    for (District dist in _selectedDistrict) {
      districtString.add(dist.districtName);
    }
    return districtString;
  }

  int? get schoolTypeCode {
    return _schoolCode;
  }

  String? get schoolType {
    return _schoolType;
  }

  int get sortBy {
    return _sortByIdx;
  }

  void changeSort(int idx) {
    _sortByIdx = idx;
    notifyListeners();
  }

  void clearDistrict() {
    _selectedDistrict = [];
    notifyListeners();
  }

  void addDistrict(District added) {
    _selectedDistrict.add(added);
    notifyListeners();
  }

  void removeDistrict(District removed) {
    _selectedDistrict.remove(removed);
    notifyListeners();
  }

  void setSchoolType(String schoolType) {
    _schoolType = schoolType;
    // _schoolCode = _schoolTypes[schoolType]!;
    print('provider set school type: $schoolType');
    // print('provider set school code: $_schoolCode');
    notifyListeners();
  }

  void setSchoolCode(int code) {
    _schoolCode = code;
  }

  void setDistricts(List<District> districts) {
    _selectedDistrict = districts;
    // notifyListeners();
  }
}

class Recruit {
  final int realDbIdx;
  final int schoolType;
  final String subject;
  final String schoolName;
  final String detailUrl;
  final String schoolAddr;
  final String applyUntil;
  final String schoolDistrict;
  final String detailText;
  final String writer;
  final String title;
  final List<dynamic> downloads;
  bool isExpanded;

  Recruit(
      {required this.realDbIdx,
      required this.schoolType,
      required this.subject,
      required this.schoolName,
      required this.detailUrl,
      required this.schoolAddr,
      required this.applyUntil,
      required this.schoolDistrict,
      required this.detailText,
      required this.writer,
      required this.downloads,
      required this.title,
      this.isExpanded = false});

  factory Recruit.fromJson(Map<String, dynamic> json) {
    LineSplitter ls = new LineSplitter();
    List<String> detailLines = ls.convert(json['detail_text']);
    String detail = detailLines.join('\n');

    return Recruit(
      realDbIdx: json['real_db_idx'],
      schoolType: json['school_type_code'],
      subject: json['subject'],
      schoolName: json['school_name'],
      detailUrl: json['detail_url'],
      schoolAddr: json['school_addr'],
      applyUntil: json['apply_until'],
      schoolDistrict: json['school_district'],
      detailText: detail,
      writer: json['writer'],
      downloads: json['downloads'],
      title: json['title'],
    );
  }
}

Future<List<Recruit>> fetchRecruits() async {
  String urlPrefix = "https://api.com";
  List<Recruit> recruits = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? schoolType = prefs.getString('school');
  print('school type saved: $schoolType');
  schoolType ??= "초등학교";

  int? sortBy = prefs.getInt('sortBy');
  sortBy ??= 1;

  List<String>? savedDistricts = prefs.getStringList('districts');
  print("saved Districts: $savedDistricts");
  savedDistricts ??= [];
  if (savedDistricts.isNotEmpty) {
    List<Future> apis = [];
    print("fetchRecruits sortBy: $sortBy");
    for (String district in savedDistricts) {
      String urlString = '$urlPrefix?s_type=$schoolType&district=$district';
      if (sortBy == 0) {
        urlString += '&sort_idx=1';
      }
      var url = Uri.parse(urlString);
      apis.add(http.get(url));
    }
    var responses = await Future.wait(apis);
    for (var response in responses) {
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // print(response.body);
        var res = jsonDecode(response.body);
        // print(res["Items"][1]["subject"]);
        List<dynamic> items = res["Items"];
        if (items.length != 0) {
          for (var item in items) {
            recruits.add(Recruit.fromJson(item));
          }
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
    }
    return recruits;
  } else {
    String urlString = '$urlPrefix?s_type=$schoolType';
    if (sortBy == 0) {
      urlString += '&sort_idx=1';
    }
    var url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var res = jsonDecode(response.body);
      List<Recruit> recruits = [];
      List<dynamic> items = res["Items"];
      if (items.length != 0) {
        // print(res["Items"][1]["subject"]);
        for (var item in items) {
          recruits.add(Recruit.fromJson(item));
        }
      }
      return recruits;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
