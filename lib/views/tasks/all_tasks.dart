import 'package:flutter/material.dart';
import 'package:goal_manager/utilities/enums.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/task_model.dart';


class TasksPage extends StatelessWidget {
  const TasksPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); 

    var allTasks= appState.db.getAllTasks(); 

    // TODO: implement build
    return FutureBuilder(
      future: allTasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return allTasksDisplay(snapshot.data, appState, context); 
        }else{
          return CircularProgressIndicator(
            backgroundColor: Colors.black,
            color: Color.fromARGB(255, 233, 193, 108)
          ); 
        }
      }); 
  }

  Widget allTasksDisplay(List<TaskModel>? allTasks, MyAppState appState, BuildContext context) {
        final Color backgroundColor = Colors.black87!; // Subtle background color
    final Color appBarBackgroundColor = Colors.black87; // Transparent AppBar
    final Color emptyStateIconColor = Color.fromARGB(255, 233, 193, 108); // Icon color for empty state
    final Color emptyStateTextColor =
        Colors.grey[600]!; // Text color for empty state
    // final Color cardGradientEnd = Colors.amber[700]!; // Start of gradient for cards
    // final Color cardGradientStart = Color.fromARGB(255, 233, 193, 108); // End of gradient for cards
    final Color cardGradientEnd =
        Colors.grey[700]!; // Start of gradient for cards
    final Color cardGradientStart = Colors.black54;
    final Color cardShadowColor =
        Colors.grey.withOpacity(0.2); // Shadow color for cards
    final Color cardTextColor =
        Color.fromARGB(255, 233, 193, 108); // Text color on cards
    final Color dueDateBackgroundColor =
        Colors.white.withOpacity(0.2); // Background for due date container
    final Color fabBackgroundColor =
        Color.fromARGB(255, 233, 193, 108); // Floating Action Button background
    final Color fabIconColor = Colors.black; // Icon color on FAB



        
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar( 
        title: Text(
          'Your Tasks', 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            letterSpacing: 1.2,
          )
        ), 
        elevation: 0, 
        backgroundColor: appBarBackgroundColor,
      ), 
      body: allTasks == null || allTasks.isEmpty 
      ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 60,
                    color: emptyStateIconColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Create your first task!",
                    style: TextStyle(
                      fontSize: 20,
                      color: emptyStateTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
            : Padding (
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
              child: ListView.builder(
                physics: const BouncingScrollPhysics(), 
                itemCount: allTasks.length, 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // TODO: Build out task cards. 
                  ); 
                }
              )
            ), 
            floatingActionButton: FloatingActionButton(
              backgroundColor: fabBackgroundColor,
              elevation: 4, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
              child: Icon(
                Icons.add, 
                size: 28, 
                color: fabIconColor), 
              onPressed: () {

               appState.selectedTask = TaskModel(
                id: 0, 
                title: '', 
                description: '', 
                frequency: Frequency.Daily, 
                shouldBeReminded: false, 
                completions: []
              ); 
                appState.setSelectedPage(4); 
              }
            )
            );
  }

}


/* 

Sketch of Layout: 

-----------------------------------------------------------
| ▸ Tasks Due                                             | 
| Task 1                                                  |
| Task 2                                                  |
| Task 3                                                  |
| Task 4                                                  |
| Task 5                                                  |
| Task 6                                                  |                                                         
-----------------------------------------------------------
-----------------------------------------------------------
| ▸ Daily Tasks                                           | 
-----------------------------------------------------------
-----------------------------------------------------------
| ▸ Weekly Tasks                                          | 
-----------------------------------------------------------
-----------------------------------------------------------
| ▸ Monthly Tasks                                         |  
-----------------------------------------------------------

*/ 