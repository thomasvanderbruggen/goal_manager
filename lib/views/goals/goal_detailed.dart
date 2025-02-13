import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:goal_manager/models/goal_metrics.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../main.dart';

class GoalDetailed extends StatefulWidget {
  const GoalDetailed({super.key});

  @override
  State<GoalDetailed> createState() => _GoalDetailed();
}

class _GoalDetailed extends State<GoalDetailed> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    GoalModel selectedGoal = appState.selectedGoal;

    return Scaffold(
        appBar: AppBar(
          title: Text('Goals'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.db.deleteGoal(selectedGoal).then((value) {
                  appState.setSelectedPage(2);
                });
              },
            )
          ],
        ),
        body: Center(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: TextFieldDecorator('Goal'),
                    initialValue: selectedGoal.title,
                    onChanged: (newString) {
                      setState(() {
                        selectedGoal.title = newString;
                      });
                    })),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _selectedDate().then((newDate) {
                          if (newDate != null) {
                            setState(() {
                              selectedGoal.goalDate = newDate;
                            });
                          }
                        });
                      },
                      child: Text(
                          'Goal Date: ${displayDate(selectedGoal.goalDate)}')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _selectedDate().then((newDate) {
                          if (newDate != null) {
                            setState(() {
                              selectedGoal.stretchDate = newDate;
                            });
                          }
                        });
                      },
                      child: Text(
                          'Stretch Date: ${displayDate(selectedGoal.stretchDate)}')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _selectedDate().then((newDate) {
                          if (newDate != null) {
                            setState(() {
                              selectedGoal.completeDate = newDate;
                            });
                          }
                        });
                      },
                      child: Text(
                          'Completed Date: ${selectedGoal.completeDate == null ? 'Uncompleted' : displayDate(selectedGoal.goalDate)}')),
                ),
              ],
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
            Expanded(
              child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: showMetrics(appState, selectedGoal)),
            ),
          ]),
        ),
        bottomSheet: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: BeveledRectangleBorder(),
            ),
            icon: Icon(Icons.add),
            label: Text("Save"),
            onPressed: () {
              if (selectedGoal.id != null) {
                appState.db.updateGoal(selectedGoal);
              } else {
                appState.db.insertGoal(selectedGoal);
              }

              appState.setSelectedPage(2);
            }));
  
  }

  List<Widget> showMetrics(MyAppState appState, GoalModel g) {
    List<Widget> widgets= []; 

    ElevatedButton addMetric = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: BeveledRectangleBorder()
      ), 
      icon: Icon(Icons.add), 
      label: Text("Add a Metric!"), 
      onPressed: () {
        appState.setSelectedPage(4); 
      }
    );

    if (g.metrics == null) {
      widgets.add(addMetric);
      return widgets;
    }

    for (GoalMetrics gm in g.metrics!) {
      widgets.add(Flexible(child: Text(gm.title)));
    }
    widgets.add(addMetric); 

    return widgets;
  }

  Future<DateTime?> _selectedDate() async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime(2000, 1, 1),
        lastDate: DateTime(2100, 1, 1));
  }

  InputDecoration TextFieldDecorator(String field) {
    return InputDecoration(border: OutlineInputBorder(), labelText: field);
  }

  String displayDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
