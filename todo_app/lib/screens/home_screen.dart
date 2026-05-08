import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart'; // ← thêm import này

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController controller = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // ← THÊM: dọn dẹp controller khi widget bị xóa khỏi cây widget
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void loadTasks() async {
    try { // ← THÊM: bắt lỗi nếu DB có vấn đề
      final data = await DatabaseHelper.instance.getTasks();
      setState(() {
        tasks = data;
      });
    } catch (e) {
      debugPrint('Lỗi load tasks: $e');
    }
  }

  void addTask() async {
    if (controller.text.isEmpty) return;
    try {
      await DatabaseHelper.instance.insertTask(
        Task(title: controller.text)
      );
      controller.clear();
      loadTasks();
    } catch (e) {
      debugPrint('Lỗi add task: $e');
    }
  }

  void deleteTask(int id) async {
    try {
      await DatabaseHelper.instance.deleteTask(id);
      loadTasks();
    } catch (e) {
      debugPrint('Lỗi delete task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo SQLite"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task"
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                // ← SỬA: dùng TaskTile thay vì ListTile trực tiếp
                return TaskTile(
                  task: task,
                  onDelete: () => deleteTask(task.id!),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}