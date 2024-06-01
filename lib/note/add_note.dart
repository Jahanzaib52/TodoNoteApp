import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_notes/color_list.dart';
import 'package:todo_notes/note/note.dart';
import 'package:todo_notes/note/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  final bool isUpdating;
  final Note? note;
  const AddNoteScreen({super.key, this.isUpdating = false, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late String title;
  late String content;
  //int colorIndex=0;
  ValueNotifier<int> indexOfColor = ValueNotifier<int>(0);
  //int indexOfColor=0;
  void addNewNote() {
    Note note = Note(
      user: "currentUser",
      title: title,
      content: content,
      dateTime: DateTime.now(),
      colorIndex: indexOfColor.value,
    );
    Provider.of<NoteProvider>(context, listen: false).addNote(note);
    Navigator.pop(context);
  }

  void updateThisNote() {
    widget.note!.title = title;
    widget.note!.content = content;
    widget.note!.colorIndex=indexOfColor.value;
    Provider.of<NoteProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdating == true) {
      title = widget.note!.title;
      content = widget.note!.content;
      indexOfColor.value=widget.note!.colorIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: widget.isUpdating == false
                ? () {
                    addNewNote();
                  }
                : () {
                    updateThisNote();
                  },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          indexOfColor.value = index;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(),
                            color: colorList[index],
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: indexOfColor,
                        builder: (context,child){
                          if(indexOfColor.value==index){
                            return const Icon(Icons.check);
                          }
                          return const SizedBox();
                        },
                      ),
                      //context.watch<NoteProvider>().notes[index].colorIndex==index? Icon(Icons.check):SizedBox(),
                    ],
                  );
                },
              ),
            ),
            TextFormField(
              initialValue: widget.isUpdating == true ? title : null,
              onChanged: (value) {
                title = value;
              },
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black12,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: widget.isUpdating == true ? content : null,
                onChanged: (value) {
                  content = value;
                },
                maxLines: null,
                textInputAction: TextInputAction.newline,
                //focusNode: FocusNode(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Start typing content...",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
