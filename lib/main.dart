import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_notes/note/note_provider.dart';
import 'package:todo_notes/note/note_screen.dart';
import 'package:todo_notes/settings/setting_screen.dart';
import 'package:todo_notes/note/sql_helper.dart';
import 'package:todo_notes/task/task_provider.dart';
import 'package:todo_notes/task/task_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SQLHelper.database;
  runApp(
    const NoteToDoApp(),
  );
}

class NoteToDoApp extends StatefulWidget {
  const NoteToDoApp({super.key});

  @override
  State<NoteToDoApp> createState() => _NoteToDoAppState();
}

class _NoteToDoAppState extends State<NoteToDoApp> {
  int selectedIndex = 0;
  List<Widget> tabs = const [
    NotesScreen(),
    ToDoScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: tabs[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.note_outlined),
                label: "NOTES",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: "TODO",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
