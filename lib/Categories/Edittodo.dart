import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/Categories/HomeView.dart';

class EditScreen extends StatelessWidget {
  final Todo todo;

  const EditScreen({super.key, required this.todo});

  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      final CollectionReference todoCollection =
          FirebaseFirestore.instance.collection('Todo');
      await todoCollection.doc(updatedTodo.id).update(updatedTodo.toMap());
      print('Todo with ID ${updatedTodo.id} updated successfully!');
    } catch (e) {
      print('Failed to update todo: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: todo.title);
    TextEditingController descriptionController =
        TextEditingController(text: todo.description);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: const Center(
            child: Text(
              'Edit Todo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          )),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Todo updatedTodo = Todo(
                  id: todo.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  dateTime: todo.dateTime,
                  priority: todo.priority,
                  completed: todo.completed,
                );

                try {
                  await updateTodo(updatedTodo);
                  Navigator.pop(context);
                  HomeView.of(context)?.reloadTodos();
                } catch (e) {
                  print('Error updating todo: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update todo: $e'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
