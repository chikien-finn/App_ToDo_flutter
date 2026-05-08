import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {

  // Singleton: chỉ 1 instance duy nhất trong toàn app
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Constructor private: bên ngoài không new được, phải dùng instance
  DatabaseHelper._init();

  // Getter: lần đầu gọi thì mở DB, lần sau trả về cái đã có
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Lấy đường dẫn thư mục storage của app trên device
    final dbPath = await getDatabasesPath();
    // Ghép đường dẫn đúng format cho từng OS
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // chỉ chạy lần đầu tiên, khi file .db chưa tồn tại
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}