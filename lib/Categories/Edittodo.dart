import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/Categories/HomeView.dart';

class EditTodo extends StatefulWidget {
  final Todo todo;

  EditTodo({required this.todo});

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTodoAndReload() async {
    Todo updatedTodo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: widget.todo.dateTime,
      priority: widget.todo.priority,
      completed: widget.todo.completed,
    );

    try {
      await _updateTodoInFirestore(updatedTodo);
      Navigator.pop(context, true);
    } catch (e) {
      print('Failed to update todo: $e');
    }
  }

  Future<void> _updateTodoInFirestore(Todo updatedTodo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Todo')
          .doc(widget.todo.title)
          .update(updatedTodo.toMap());
      print('Todo updated successfully');
    } catch (e) {
      print('Failed to update todo: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateTodoAndReload,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
