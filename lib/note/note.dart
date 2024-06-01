class Note {
  final int? id;
  final String? user;
  String title;
  String content;
  final DateTime dateTime;
  bool isSelected;
  int colorIndex;
  Note({
    this.id,
    this.user,
    required this.title,
    required this.content,
    required this.dateTime,
    this.isSelected = false,
    this.colorIndex = 0,
  });
  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "user": user,
      "title": title,
      "content": content,
      "dateTime": dateTime.toIso8601String(),
      "isSelected": isSelected ? 1 : 0,
      "colorIndex": colorIndex,
    };
  }

  void toggleSelection() {
    isSelected = !isSelected;
  }

  @override
  String toString() {
    return "Note{id:$id,user:$user,title:$title,content:$content,"
    "dateTime:$dateTime,isSelected:$isSelected,colorIndex:$colorIndex,}";
  }
}
