class Task {
  int? id;
  String title;

  Task({this.id, required this.title});

  // toMap() dùng khi INSERT hoặc UPDATE vào SQLite
  // Khi INSERT mới: KHÔNG truyền id → SQLite tự AUTOINCREMENT
  // Khi UPDATE: CÓ id → SQLite biết sửa row nào
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,  // ← CHỈ đưa id vào nếu nó có giá trị
      'title': title,
    };
  }

  // fromMap() dùng khi ĐỌC từ SQLite ra, map cột DB → object Dart
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
    );
  }
}