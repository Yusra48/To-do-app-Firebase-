import 'package:application/Categories/HomeView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Addtodo extends StatefulWidget {
  final VoidCallback onTodoAdded;

  const Addtodo({Key? key, required this.onTodoAdded}) : super(key: key);

  @override
  State<Addtodo> createState() => AddtodoState();
}

class AddtodoState extends State<Addtodo> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Priority selectedPriority = Priority.low;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {});
    }
  }

  Future<void> _selectTime() async {
    selectedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {});
    }
  }

  DateTime get selectedDateTime {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    } else {
      return DateTime.now();
    }
  }

  Widget buildPriorityDropdown() {
    return DropdownButton<Priority>(
      value: selectedPriority,
      items: Priority.values
          .map((priority) => DropdownMenuItem(
                value: priority,
                child: Text(
                  priority.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(color: Colors.deepPurpleAccent),
                ),
              ))
          .toList(),
      onChanged: (value) => setState(() => selectedPriority = value!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Add a new task',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime?.format(context) ?? 'Pick Time',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              buildPriorityDropdown(),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () async {
                  String title = _titleController.text.trim();
                  String description = _descriptionController.text.trim();

                  if (title.isEmpty || description.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter both title and description'),
                      ),
                    );
                    return;
                  }

                  Todo newTodo = Todo(
                    title: title,
                    description: description,
                    dateTime: selectedDateTime,
                    priority: selectedPriority,
                  );

                  try {
                    await FirebaseFirestore.instance
                        .collection("todos")
                        .add(newTodo.toMap());
                    print("Todo added successfully!");
                    widget.onTodoAdded();
                    Navigator.of(context).pop();
                  } catch (error) {}
                },
                child: const Text('Save'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
