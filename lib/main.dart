import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_todo/database.dart';

late AppDatabase db;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoApplication(title: 'Todo Application'),
    );
  }
}

class TodoApplication extends StatefulWidget {
  const TodoApplication({super.key, required this.title});

  final String title;

  @override
  State<TodoApplication> createState() => _TodoApplicationState();
}

class _TodoApplicationState extends State<TodoApplication> {
  late List<TodoItem> todoItems = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    var tmp = await db.allTodoItems;
    setState(() {
      todoItems = tmp;
    });
  }

  void submitHandler(value) async {
    await db.addTodo(TodoItemsCompanion(content: Value(value)));
    refreshList();
  }

  void toggleHandler(idx) async {
    await db.flipTodoDoneStatus(idx);
    refreshList();
  }

  void deleteHandler(idx) async {
    await db.delTodo(idx);
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TodoInput(onSubmit: submitHandler),
            const SizedBox(height: 30.0),
            Expanded(
              child: ListView.builder(
                itemCount: todoItems.length,
                itemBuilder: (ctx, idx) {
                  TodoItem i = todoItems[idx];
                  return TodoListItem(
                    idx: i.idx,
                    content: i.content,
                    isDone: i.isDone,
                    onToggle: toggleHandler,
                    onDelete: deleteHandler,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.idx,
    required this.content,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
  });

  final int idx;
  final String content;
  final bool isDone;
  final Function onToggle;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    final TextStyle ts = TextStyle(
      decoration: (isDone ? TextDecoration.lineThrough : TextDecoration.none),
      color: isDone ? Colors.grey : Colors.black,
    );

    return ListTile(
      title: Text(content, style: ts),
      onTap: () => onToggle(idx),
      trailing: IconButton(
        onPressed: () => onDelete(idx),
        icon: const Icon(Icons.delete_forever_sharp),
      ),
    );
  }
}

class TodoInput extends StatelessWidget {
  TodoInput({super.key, required this.onSubmit});

  final TextEditingController _textController = TextEditingController();
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (content) => onSubmit(_textController.text),
            controller: _textController,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        SizedBox(width: 20.0),
        ElevatedButton(
          onPressed: () => onSubmit(_textController.text),
          child: Text("등록"),
        ),
      ],
    );
  }
}
