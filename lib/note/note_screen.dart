import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_notes/note/add_note.dart';
import 'package:todo_notes/color_list.dart';
import 'package:todo_notes/note/note.dart';
import 'package:todo_notes/note/note_provider.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState(){
    super.initState();
    context.read<NoteProvider>().loadNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: context.watch<NoteProvider>().isVisible == true
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  context.read<NoteProvider>().toggleVisibility();
                },
                icon: const Icon(Icons.close),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    for (var note
                        in Provider.of<NoteProvider>(context, listen: false)
                            .notes) {
                      context.read<NoteProvider>().updateSelection(note);
                    }
                  },
                  icon: const Icon(Icons.checklist),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (contex) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            content: const Text(
                                "Are you sure you want to delete note?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<NoteProvider>().deleteNote();
                                  context
                                      .read<NoteProvider>()
                                      .toggleVisibility();
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            )
          : null,

          //----------------------------------------------//
          //----------------------------------------------//
          //----------------------------------------------//


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                elevation: const MaterialStatePropertyAll(0),
                leading: const Icon(Icons.search),
                backgroundColor:
                    MaterialStatePropertyAll(Colors.blueGrey.withOpacity(0.2)),
                hintText: "Search Notes...",
                trailing: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),

              //----------------------------------------------//
          //----------------------------------------------//
          //----------------------------------------------//

          
              Expanded(
                child: Consumer<NoteProvider>(
                    builder: (context, noteProvider, child) {
                  return GridView.builder(
                      itemCount: noteProvider.notes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final Note note = noteProvider.notes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNoteScreen(
                                  isUpdating: true,
                                  note: note,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            noteProvider.toggleVisibility();
                            noteProvider.updateSelection(note);
                          },
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 2,
                                  color: colorList[note.colorIndex],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          note.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            note.content,
                                            textAlign: TextAlign.left,
                                            maxLines: 5,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Text(
                                          DateFormat.yMMMMd()
                                              .format(noteProvider
                                                  .notes[index].dateTime)
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: noteProvider.isVisible,
                                child: Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: IconButton(
                                    onPressed: () {
                                      noteProvider.updateSelection(note);
                                    },
                                    icon: note.isSelected == false
                                        ? const Icon(
                                            Icons.check_box_outline_blank)
                                        : const Icon(Icons.check_box),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddNoteScreen();
              },
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
