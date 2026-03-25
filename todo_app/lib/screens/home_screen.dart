import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

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

  void loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  void addTask() async {

    if(controller.text.isEmpty) return;

    await DatabaseHelper.instance.insertTask(
      Task(title: controller.text)
    );

    controller.clear();
    loadTasks();
  }

  void deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    loadTasks();
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
              itemBuilder: (context,index){

                final task = tasks[index];

                return ListTile(
                  title: Text(task.title),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (){
                      deleteTask(task.id!);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}