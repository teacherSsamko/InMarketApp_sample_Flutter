import 'package:flutter/material.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruitTile extends StatelessWidget {
  RecruitTile({required this.item, this.tileCallback});

  final Recruit item;
  final Function(bool?)? tileCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('마감: ${item.applyUntil}'),
          SizedBox(height: 10),
          Text(
            '${item.detailText}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text('${item.schoolAddr}'),
          Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
                onPressed: () {
                  print("원문보기");
                  _launchURL(item.detailUrl);
                },
                child: Text(
                  "원문보기",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              TextButton(
                style: item.downloads.length != 0
                    ? detailButtonStyle
                    : disabledButtonStyle,
                onPressed: () {
                  if (item.downloads.length == 0) return;
                  String? previewUrl = item.downloads[0]!["preview"];
                  previewUrl = previewUrl!.replaceAll(" ", "+");
                  print(previewUrl);
                  var url = Uri.parse(previewUrl).toString();
                  _launchURL(url);
                },
                child: item.downloads.length != 0
                    ? attachedText("첨부파일 미리보기")
                    : attachedText("첨부파일 없음"),
              ),
            ],
          ),
        ],
      ),
      subtitle: Text(item.schoolDistrict),
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  void _attachedPreview() {
    String? previewUrl = this.item.downloads[0]!["preview"];
    previewUrl = previewUrl!.replaceAll(" ", "+");
    print(previewUrl);
    var url = Uri.parse(previewUrl).toString();
    _launchURL(url);
  }
}

class attachedText extends StatelessWidget {
  final String name;
  const attachedText(this.name);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.name,
      style: TextStyle(fontSize: 12.0),
    );
  }
}

ButtonStyle detailButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
);

ButtonStyle disabledButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
);
