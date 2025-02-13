import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/goal_model.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var allGoals = appState.db.getAllGoals();

    return FutureBuilder(
        future: allGoals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return allGoalsDisplay(snapshot.data, appState);
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
            );
          }
        });
    // TODO: implement build
    // return (
    //   ListView(
    //     children: [
    //       for (GoalModel goal in goals) ElevatedButton(onPressed: () {handlePress(goal); }, child: Text(goal.title))
    //     ],
    //   )
    // );
  }

  Scaffold allGoalsDisplay(List<GoalModel>? allGoals, MyAppState appState) {
    return Scaffold(
        appBar: AppBar(title: Text('Goals')),
        body: allGoals == null || allGoals.isEmpty
            ? SizedBox(
                height: 300,
                width: 300,
                child: Text("Add a goal to get started!"),
              )
            : ListView(children: [
                for (var g in allGoals)
                  ElevatedButton(
                    onPressed: () {
                      appState.selectedGoal = g;
                      appState.setSelectedPage(3);
                    },
                    child: Text(g.title),
                  )
              ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              appState.selectedGoal = GoalModel.appGen('', '', [], DateTime(1901, 1,1), DateTime(1901,1,1), null, ''); 
              appState.setSelectedPage(3); 

              //appState.db.resetDatabase().then((value) { appState.refresh(); },
              // appState.db.insertTestData().then((value) {
              //   appState.refresh();
              // });
              // appState.db.insertGoal(GoalModel.appGen('Title', 'Description', ['1,2,3'], DateTime.now(), 'Monthly'));
              // appState.refresh();
            }));
  }
}
