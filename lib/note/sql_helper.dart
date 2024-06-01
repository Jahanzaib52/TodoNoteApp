import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../task/task.dart';
import 'note.dart';

class SQLHelper {
  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await initilizeDB();
  }

  static Future initilizeDB() async {
    final path = join(await getDatabasesPath(), "notes.db");
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  static Future onCreate(Database db, int version) async {
    Batch batch=db.batch();
    batch.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT NULL,
        title TEXT NOT NULL,
        content NOT NULL,
        dateTime TEXT NOT NULL,
        isSelected BOOL NOT NULL,
        colorIndex INTEGER NOT NULL
      )
      ''');
      batch.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT NULL,
        title TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        isDone BOOL NOT NULL
      )
      ''');
      batch.commit();
  }
  

  static Future createNote(Note note) async {
    final db = await database;
    await db.insert("notes", note.toMap());
  }

  static Future<List<Map>> readNotes() async {
    final db = await database;
    return await db.query("notes", orderBy: "dateTime DESC");
  }

  static Future updateNote(Note note) async {
    final db = await database;
    await db.update("notes", note.toMap(), where: "id=?", whereArgs: [note.id]);
  }

  static Future deleteSelectedNote() async {
    final db = await database;
    await db.delete("notes", where: "isSelected=?", whereArgs: [1]);
  }

  static Future updateSelection(Note note) async {
    final db = await database;
    await db.update("notes", {"isSelected": note.isSelected ? 0 : 1},
        where: "id=?", whereArgs: [note.id]);
  }
  //------------------------------------------------------------------------//
  //-------------------------------CRUD------------------------------------//
  //----------------------------------------------------------------------//
  static Future createtTask(Task task) async{
    final db=await database;
    await db.insert("todos", task.toMap());
  }
  static Future<List<Map>> readTask() async{
    final db=await database;
    return await db.query("todos",orderBy: "dateTime DESC");
  }
  static Future updateTask(Task task) async{
    final db=await database;
    await db.update("todos", {"title":task.title},where: "id=?",whereArgs: [task.id]);
  }
  static Future isDone(Task task) async{
    final db=await database;
    await db.update("todos", {"isDone":task.isDone?0:1},where:"id=?",whereArgs: [task.id]);
  }
  static Future deleteTask(int id) async{
    final db=await database;
    await db.delete("todos",where: "id=?",whereArgs: [id]);
  }
}
