import 'package:localdatabase/sqflite/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class NotesDataBase {
  static final NotesDataBase instance = NotesDataBase._init();
  NotesDataBase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb("notes.db");
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbpath = await getDatabasesPath();
    String path = join(dbpath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  close() async {
    final db = await instance.database;
    db.close();
  }

  _onCreate(Database db, int version) async {
    const idType = " INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = " BOOLEAN NOT NULL";
    const intType = " INTEGER NOT NULL";
    const textType = " TEXT NOT NULL";

    await db.execute('''
          CREATE TABLE $tableNote (
            ${NoteFields.id}$idType,
            ${NoteFields.description}$textType,
            ${NoteFields.title}$textType,
            ${NoteFields.time}$textType,
            ${NoteFields.isImportant}$boolType,
            ${NoteFields.number}$intType
            )
          ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNote, note.tojson());
    return note.copy(
      id: id,
    );
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNote,
        columns: NoteFields.values,
        where: "${NoteFields.id} = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromjson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = "${NoteFields.time} ASC";
    //custom query
    // final results = await db.rawQuery('SELECT * FROM $tableNote ORDER BY $orderBy');
    final results = await db.query(tableNote, orderBy: orderBy);
    return results.map((json) => Note.fromjson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(tableNote, note.tojson(),
        where: "${NoteFields.id} = ?", whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(tableNote, where: "${NoteFields.id} = ?", whereArgs: [id]);
  }
}
