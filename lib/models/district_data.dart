class Task {
  final String taskName;
  bool isDone;

  Task({this.taskName = "task", this.isDone = false});

  void toggleCheck() {
    isDone = !isDone;
  }
}

class District {
  final String districtName;
  bool isSelected = false;

  District(this.districtName);

  void toggleCheck() {
    isSelected = !isSelected;
  }

  @override
  String toString() {
    return '$districtName';
  }
}
