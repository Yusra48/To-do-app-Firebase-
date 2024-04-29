import 'package:application/Categories/Edittodo.dart';
import 'package:application/Navigations/Addtodo.dart';
import 'package:application/Navigations/Calendar.dart';
import 'package:application/Navigations/ProfileView.dart';
import 'package:application/Navigations/Settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<Todo> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Todo').get();

      setState(() {
        _todos =
            querySnapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading todos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTodoInFirestore(Todo updatedTodo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Todo')
          .doc(updatedTodo.title)
          .update(updatedTodo.toMap());
      print('Todo updated successfully');
    } catch (e) {
      print('Failed to update todo: $e');
    }
  }

  void _showDeleteConfirmation(String todoTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text('Confirm Delet'),
          content: Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTodo(todoTitle);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTodo(String todoTitle) async {
    try {
      await FirebaseFirestore.instance
          .collection('Todo')
          .doc(todoTitle)
          .delete();
      print('Todo deleted successfully');
      _loadTodos();
    } catch (e) {
      print('Failed to delete todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.sort_outlined,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://cdn.pixabay.com/photo/2018/08/03/12/18/wolf-3581809_640.jpg',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _todos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn.pixabay.com/photo/2017/01/31/13/45/checklist-2024181_640.png',
                        height: 100,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'No tasks to show',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Tap + to add your tasks',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    Todo todo = _todos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            todo.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: GestureDetector(
                            onTap: () {
                              setState(() {
                                todo.completed = !todo.completed;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: todo.completed
                                      ? Colors.green
                                      : Colors.black,
                                  width: 2.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: todo.completed
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 24.0,
                                    )
                                  : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTodo(todo: todo),
                                    ),
                                  );
                                  if (result != null && result) {
                                    _loadTodos();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  _showDeleteConfirmation(todo.title);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addtodo(
                onTodoAdded: (Todo value) {},
              ),
            ),
          ).then((value) {
            _loadTodos();
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepPurpleAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        backgroundColor: Colors.black38,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home, color: Colors.white, size: 25),
          ),
          BottomNavigationBarItem(
            label: 'Focus',
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 25),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person, color: Colors.white, size: 25),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings, color: Colors.white, size: 25),
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FocusView(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileView(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

enum Priority { low, medium, high }

class Todo {
  final String title;
  final String description;
  final DateTime dateTime;
  final Priority priority;
  bool completed;
  bool checked;

  Todo({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    this.completed = false,
    this.checked = false,
  });
  factory Todo.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todo(
      title: data['title'],
      description: data['description'],
      dateTime: DateTime.parse(data['dateTime']),
      priority: Priority.values.firstWhere((priority) =>
          priority.toString().split('.').last.toUpperCase() ==
          data['priority']),
      completed: data['completed'] ?? false,
      checked: data['checked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority.toString().split('.').last.toUpperCase(),
      'completed': completed,
      'checked': checked,
    };
  }
}
