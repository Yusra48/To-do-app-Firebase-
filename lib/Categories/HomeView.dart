import 'package:application/Navigations/Addtodo.dart';
import 'package:application/Navigations/ProfileView.dart';
import 'package:application/Navigations/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  factory Todo.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      title: data['title'],
      description: data['description'],
      dateTime: DateTime.parse(data['dateTime']),
      priority: Priority.values
          .firstWhere((e) => e.toString().toUpperCase() == data['priority']),
      completed: data['completed'] ?? false,
      checked: data['checked'] ?? false,
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _firestore = FirebaseFirestore.instance.collection('Todo');
  List<Todo> _todos = [];
  @override
  void initState() {
    super.initState();
    refreshTodos();
  }

  Future<void> refreshTodos() async {
    try {
      final todosRef = FirebaseFirestore.instance.collection('Todo');
      final snapshot = await todosRef.get();

      setState(() {
        _todos = snapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
      });
    } catch (e) {
      print('Error refreshing todos: $e');
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos =
              snapshot.data!.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
          return todos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn.pixabay.com/photo/2017/01/31/13/45/checklist-2024181_640.png',
                        height: 100,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'What do you want to do today?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Tap + to add your tasks',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    Todo todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              todo.checked
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                            onPressed: () {
                              setState(() {
                                todo.checked = !todo.checked;
                              });
                            },
                          ),
                          trailing: const Icon(Icons.edit, color: Colors.white),
                          title: Text(
                            todo.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepPurpleAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        backgroundColor: Colors.black38,
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home, color: Colors.white, size: 25),
          ),
          const BottomNavigationBarItem(
            label: 'Calendar',
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 25),
          ),
          BottomNavigationBarItem(
            label: 'Add',
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.add, size: 38.0, color: Colors.grey),
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person, color: Colors.white, size: 25),
          ),
          const BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings, color: Colors.white, size: 25),
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              //  Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ,
              //     ),
              //   );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addtodo(
                    onTodoAdded: () {
                      refreshTodos();
                    },
                  ),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileView(),
                ),
              );
              break;
            case 4:
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
