import 'package:application/Categories/HomeView.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addtodo extends StatefulWidget {
  final ValueChanged<Todo> onTodoAdded;

  const Addtodo({Key? key, required this.onTodoAdded}) : super(key: key);

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Priority selectedPriority = Priority.low;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveTodo() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter all fields'),
      ));
      return;
    }

    final newTodo = Todo(
      title: title,
      description: description,
      dateTime: DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ),
      priority: selectedPriority,
    );

    try {
      await FirebaseFirestore.instance.collection('Todo').add(newTodo.toMap());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Todo added successfully'),
      ));
      widget.onTodoAdded(newTodo); // Notify the parent widget with the new todo
      Navigator.of(context).pop(); // Close the Addtodo screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add todo: $e'),
      ));
    }
  }

  Widget _buildPriorityDropdown() {
    return DropdownButton<Priority>(
      value: selectedPriority,
      items: Priority.values.map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(
            priority.toString().split('.').last.toUpperCase(),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedPriority = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new task'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(selectedDate != null
                      ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                      : 'Select Date'),
                ),
                TextButton.icon(
                  onPressed: _selectTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(selectedTime != null
                      ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            _buildPriorityDropdown(),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _saveTodo,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
