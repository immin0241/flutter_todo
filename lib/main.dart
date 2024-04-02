import 'package:flutter/material.dart';

void main() {
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
  List<Map<String, dynamic>> todoItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TodoInput(),
            SizedBox(height: 30.0),
            Expanded(
              child: ListView(
                children: [
                  TodoItem(content: "ads", isDone: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.content,
    required this.isDone,
  });

  final String content;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final TextStyle ts = TextStyle(
      decoration: (isDone ? TextDecoration.lineThrough : TextDecoration.none),
      color: isDone ? Colors.grey : Colors.black,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(content, style: ts),
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.delete_forever),
        )
      ],
    );
  }
}

class TodoInput extends StatelessWidget {
  const TodoInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(),
        ),
        SizedBox(width: 20.0),
        ElevatedButton(onPressed: () => {}, child: Text("등록")),
      ],
    );
  }
}
