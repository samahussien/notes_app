import 'package:notes/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init(); //global variable
  static Database? _database;
  NotesDatabase._init(); //constructor

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEN NOT NULL";
    const integerType = 'INTEGER NOT NULL';
    const textType = "TEXT NOT NULL";
    await db.execute('''
CREATE TABLE $tableNotes (
${NoteFields.id} $idType,
${NoteFields.isImportant} $boolType,
${NoteFields.number} $integerType,
${NoteFields.title} $textType,
${NoteFields.description} $textType,
${NoteFields.time} $textType

)
''');
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id}=?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id}=?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete(tableNotes, where: '${NoteFields.id}=?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
