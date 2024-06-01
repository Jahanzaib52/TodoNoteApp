class Task {
  int? id;
  final String? user;
  String title;
  DateTime dateTime;
  bool isDone;
  Task({
    this.id,
    this.user,
    required this.title,
    required this.dateTime,
    this.isDone = false,
  });
  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "user":user,
      "title": title,
      "dateTime":dateTime.toIso8601String(),
      "isDone": isDone ? 1 : 0,
    };
  }

  void toggleDone() {
    isDone = !isDone;
  }
  @override
  String toString() {
    return "{id:$id,user:$user,title:$title,dateTime:$dateTime,isDone:$isDone}";
  }
}
