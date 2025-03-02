import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../main.dart';

class GoalDetailed extends StatefulWidget {
  const GoalDetailed({super.key});

  @override
  State<GoalDetailed> createState() => _GoalDetailed();
}

class _GoalDetailed extends State<GoalDetailed> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final goalTypeController = TextEditingController();
  var _goalEndDate = DateTime.now();
  var _isCompleted = false;
  var _priority = 0;
  final categoryController = TextEditingController();
  var _progress = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    GoalModel selectedGoal = appState.selectedGoal;

    if (selectedGoal.id > 0) {
      titleController.text = selectedGoal.title;
      descriptionController.text = selectedGoal.description;
      goalTypeController.text = selectedGoal.goalType;
      _goalEndDate = selectedGoal.goalEndDate;
      _isCompleted = selectedGoal.isCompleted;
      _priority = selectedGoal.priority;
      categoryController.text = selectedGoal.category;
      _progress = selectedGoal.progress;
    }
    bool editable = true; 
  selectedGoal.goalEndDate.isBefore(DateTime.now().subtract(Duration(days: 1))) ? editable = false : editable = true; 
  final Color backgroundColor = Colors.black87; // Deep dark background
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
              enabled: editable,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Enter a Title',
                hintStyle: TextStyle(color: hintColor),
                labelText: 'Title',
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
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description Field
            TextFormField(
              controller: descriptionController,
              enabled: editable, 
              style: TextStyle(color: textColor),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter a Description',
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

            // Goal Type Field
            TextFormField(
              controller: goalTypeController,
              enabled: editable, 
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Enter a Goal Type',
                hintStyle: TextStyle(color: hintColor),
                labelText: 'Goal Type',
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
                  return 'Please enter a goal type';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Date Picker Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: fieldFillColor,
                foregroundColor: accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              onPressed: () {
                _selectDate().then((value) {
                  setState(() {
                    if (value != null) {
                      _goalEndDate = value;
                      selectedGoal.goalEndDate = _goalEndDate;
                    }
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "Goal Date",
                      style: TextStyle(color: accentColor),
                    ),
                  ),Text(""),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Text(
                      _goalEndDate.toString().split(" ")[0],
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Field
            TextFormField(
              controller: categoryController,
              enabled: editable, 
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Enter a Category',
                hintStyle: TextStyle(color: hintColor),
                labelText: 'Category',
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
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Progress Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress: ${_progress.round()}%",
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _progress.toDouble(),
                  max: 100,
                  activeColor: accentColor,
                  inactiveColor: inactiveColor,
                  onChanged: !editable ? null : (double value) {
                    setState(() {
                      _progress = value.floor();
                      selectedGoal.progress = _progress;
                      if (_progress == 100) {
                        selectedGoal.isCompleted = true; 
                      }
                    });
                  },
                ),
              ],
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
                    selectedGoal = GoalModel(
                      id: selectedGoal.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      goalType: goalTypeController.text,
                      goalEndDate: _goalEndDate,
                      isCompleted: _isCompleted,
                      progress: _progress,
                      priority: 0,
                      category: categoryController.text,
                    );
                    appState.db.insertGoal(selectedGoal);
                    appState.setSelectedPage(2);
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Future<DateTime?> _selectDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
  }
}
