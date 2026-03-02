import 'package:flutter/material.dart';

class Todo {
  final String id;
  final String title;
  final String text;

  Todo({required this.id, required this.title, required this.text});
}

void main() {
  runApp(MaterialApp(
    title: 'Todo App',
    home: MainScreen(),
  ));
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Todo> _todos = [];

  void _addTodo(Todo todo) {
    setState(() => _todos.add(todo));
  }

  void _deleteTodo(String id) {
    setState(() => _todos.removeWhere((t) => t.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой Todo лист')),
      body: _todos.isEmpty
          ? Center(child: Text('Нет задач. Нажмите + чтобы добавить.'))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (ctx, i) => Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(_todos[i].title),
                  subtitle: Text(_todos[i].text),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(_todos[i].id),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newTodo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen()),
          );
          if (newTodo != null) _addTodo(newTodo);
        },
      ),
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Новая задача')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Сохранить'),
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _textController.text.isNotEmpty) {
                  final todo = Todo(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    text: _textController.text,
                  );
                  Navigator.pop(context, todo);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Заполните все поля!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
