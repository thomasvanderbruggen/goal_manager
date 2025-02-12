import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../main.dart';

class GoalDetailed extends StatefulWidget {
  const GoalDetailed({Key? key}) : super(key: key);

  @override
  State<GoalDetailed> createState() => _GoalDetailed();
}

class _GoalDetailed extends State<GoalDetailed> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    GoalModel selectedGoal = appState.selectedGoal;

    return Scaffold(
      appBar: AppBar(title: Text(selectedGoal.title)),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                decoration: TextFieldDecorator('Description'),
                initialValue: selectedGoal.description,
                onChanged: (newString) {
                  setState(() {
                    selectedGoal.description = newString;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  _selectedDate().then((newDate) {
                    if (newDate != null) {
                      selectedGoal.goalDate = newDate;
                    }
                  });
                },
                child: Text(selectedGoal.goalDate.toString())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: TextFieldDecorator('GoalType'),
              initialValue: selectedGoal.goalType,
              onChanged: (newString) {
                selectedGoal.goalType = newString;
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<DateTime?> _selectedDate() async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime(2100, 1, 1));
  }

  InputDecoration TextFieldDecorator(String field) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$field',
    );
  }
}
