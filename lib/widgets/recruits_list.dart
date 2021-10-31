import 'package:flutter/material.dart';
import 'package:teacher_recruit/models/recruit_data.dart';
import 'package:teacher_recruit/widgets/recruit_tile.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

/// widget for recruits
class RecruitsListWidget extends StatefulWidget {
  final List<Recruit> recruits;

  const RecruitsListWidget({required this.recruits, Key? key})
      : super(key: key);

  @override
  State<RecruitsListWidget> createState() =>
      _RecruitsListWidgetState(recruits: recruits);
}

/// This is the private State class that goes with MyStatefulWidget.
class _RecruitsListWidgetState extends State<RecruitsListWidget> {
  final List<Recruit> recruits;
  _RecruitsListWidgetState({required this.recruits});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          recruits[index].isExpanded = !isExpanded;
        });
      },
      children: recruits.map<ExpansionPanel>((Recruit item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                  '[${item.schoolDistrict}] ${item.title} - ${item.schoolName}'),
              onTap: () {
                setState(() {
                  item.isExpanded = !isExpanded;
                });
              },
            );
          },
          body: RecruitTile(
            item: item,
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
