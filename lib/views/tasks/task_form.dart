import 'package:flutter/material.dart';
import 'package:goal_manager/models/task_completion.dart';
import 'package:goal_manager/utilities/enums.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart'; 
import '../../main.dart'; 


class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskForm(); 
}


class _TaskForm extends State<TaskForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Frequency _frequency = Frequency.Daily; // Default frequency
  var _shouldBeReminded = false;
  List<TaskCompletionModel> _completions = []; // List to store completions (you might want to type this as List<DateTime> or similar)

  final _formKey = GlobalKey<FormState>();

  
  void _updateControllers(TaskModel selectedTask) {
    titleController.text = selectedTask.title;
    descriptionController.text = selectedTask.description;
    _frequency = selectedTask.frequency;
    _shouldBeReminded = selectedTask.shouldBeReminded;
    _completions = List.from(selectedTask.completions); // Copy the list to avoid mutating the original
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Get the selected task
    TaskModel selectedTask = appState.selectedTask;

    // Update controllers if the task ID changes (e.g., new task or edited task)
    if (selectedTask.id > 0 && (titleController.text != selectedTask.title || _frequency != selectedTask.frequency)) {
      _updateControllers(selectedTask);
    }

    // Color variables from your specified scheme
    final Color backgroundColor = Colors.black87!; // Deep dark background
    final Color fieldFillColor = Colors.grey[850]!; // Slightly lighter dark for fields
    final Color textColor = Colors.white70; // Slightly muted white for text
    final Color accentColor = Color.fromARGB(255, 233, 193, 108); // Vibrant amber for highlights
    final Color hintColor = Colors.grey[500]!; // Muted grey for hints
    final Color inactiveColor = Colors.grey[700]!; // Dark grey for inactive elements
    final Color buttonTextColor = Colors.white; // White text for buttons

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Enter a Title',
                  hintStyle: TextStyle(color: hintColor), // Fixed to use hintColor instead of accentColor for consistency
                  labelText: 'Title', // Added label for clarity
                  labelStyle: TextStyle(color: accentColor),
                  filled: true,
                  fillColor: fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              TextFormField(
                controller: descriptionController,
                style: TextStyle(color: textColor),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter a description', // Fixed typo: "decription" -> "description"
                  hintStyle: TextStyle(color: hintColor),
                  labelText: 'Description',
                  labelStyle: TextStyle(color: accentColor),
                  filled: true,
                  fillColor: fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Frequency Dropdown
              DropdownButtonFormField<Frequency>(
                value: _frequency,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Select Frequency',
                  hintStyle: TextStyle(color: hintColor),
                  labelText: 'Frequency',
                  labelStyle: TextStyle(color: accentColor),
                  filled: true,
                  fillColor: fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                ),
                items: [
                  DropdownMenuItem<Frequency>(
                    value: Frequency.Daily,
                    child: Text('Daily', style: TextStyle(color: textColor)),
                  ),
                  DropdownMenuItem<Frequency>(
                    value: Frequency.Monthly,
                    child: Text('Monthly', style: TextStyle(color: textColor)),
                  ),
                  DropdownMenuItem<Frequency>(
                    value: Frequency.Weekly,
                    child: Text('Weekly', style: TextStyle(color: textColor)),
                  ),
                ],
                onChanged: (Frequency? newValue) {
                  setState(() {
                    _frequency = newValue ?? Frequency.Daily; // Default to Daily if null
                  });
                },
                validator: (Frequency? value) {
                  if (value == null) {
                    return 'Please select a frequency';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: buttonTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Create or update the task
                      selectedTask = TaskModel(
                        id: selectedTask.id,
                        title: titleController.text,
                        description: descriptionController.text,
                        frequency: _frequency,
                        shouldBeReminded: _shouldBeReminded,
                        completions: _completions,
                      );
                      appState.db.insertTask(selectedTask); // Assuming this method exists
                      appState.setSelectedPage(1); // Return to tasks page (adjust as needed)
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: buttonTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}