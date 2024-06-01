import 'package:flutter/foundation.dart';
import 'package:todo_notes/note/note.dart';
import 'package:todo_notes/note/sql_helper.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> notes = [];
  bool isVisible = false;
  void addNote(Note note) async {
    await SQLHelper.createNote(note).whenComplete(() => notes.add(note));
    //print(notes);
    loadNotes();
    notifyListeners();
  }

  void loadNotes() async {
    notes=await SQLHelper.readNotes().then(
      (list) => list.map(
        (note) => Note(
          id: note["id"],
          user: note["user"],
          title: note["title"],
          content: note["content"],
          dateTime: DateTime.parse(note["dateTime"]),
          isSelected: note["isSelected"]==1?true:false,
          colorIndex: note["colorIndex"],
        ),
      ).toList(),
    );
    //print(notes);
    notifyListeners();
  }

  void updateNote(Note note) async{
    await SQLHelper.updateNote(note).whenComplete(() => loadNotes());
    // int index =
    //     notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    // notes[index] = note;
    notifyListeners();
  }

  void deleteNote() async{
    await SQLHelper.deleteSelectedNote().whenComplete(() => loadNotes());
    // List removeNoteList=[];
    // for(var note in notes.where((element) => element.isSelected==true)){
    //   removeNoteList.add(note);
    // }
    // notes.removeWhere((element) => removeNoteList.contains(element));
    //print(notes);
    notifyListeners();
  }
  void updateSelection(Note note) async{
    await SQLHelper.updateSelection(note).whenComplete(() => loadNotes());
    // note.toggleSelection();
    //print(notes);
    notifyListeners();
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
