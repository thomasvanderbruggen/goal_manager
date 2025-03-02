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
            return allGoalsDisplay(snapshot.data, appState, context);
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

  Widget allGoalsDisplay(
      List<GoalModel>? allGoals, MyAppState appState, BuildContext context) {
    // Color variables
    final Color backgroundColor = Colors.black87!; // Subtle background color
    final Color appBarBackgroundColor = Colors.black87; // Transparent AppBar
    final Color emptyStateIconColor = Colors.red!; // Icon color for empty state
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
      backgroundColor: backgroundColor, // Subtle background color
      appBar: AppBar(
        title: const Text(
          'Your Goals',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        backgroundColor: appBarBackgroundColor,
      ),
      body: allGoals == null || allGoals.isEmpty
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
                    "Create your first goal!",
                    style: TextStyle(
                      fontSize: 20,
                      color: emptyStateTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: allGoals.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      appState.selectedGoal = allGoals[index];
                      appState.setSelectedPage(3);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cardGradientStart,
                            cardGradientEnd,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor,
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleDisplay(allGoals[index]),
                            const SizedBox(height: 8),
                            Text(
                              allGoals[index].description,
                              style: TextStyle(
                                fontSize: 14,
                                color: cardTextColor.withOpacity(0.9),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: dueDateBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Due: ${allGoals[index].goalEndDate.toString().split(" ")[0]}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cardTextColor.withOpacity(0.95),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabBackgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.add,
          size: 28,
          color: fabIconColor,
        ),
        onPressed: () {
          appState.selectedGoal = GoalModel(
            id: 0,
            title: '',
            description: '',
            goalType: '',
            goalEndDate: DateTime.now(),
            isCompleted: false,
            progress: 0,
            priority: 1,
            category: '',
          );
          appState.setSelectedPage(3);
        },
      ),
    );
  }

  Widget titleDisplay(GoalModel goal) {
    Color color = Color.fromARGB(255, 233, 193, 108);
    String textString = goal.title;
    if (goal.isCompleted) {
      textString += ' ✅';
      color = Colors.green[200]!;
    } else if (!goal.isCompleted &&
        (goal.goalEndDate.isAfter(DateTime.now()))) {
      goal.goalEndDate.difference(DateTime.now()).inDays < 10
          ? textString += ' ⌛'
          : textString += ' ⏳';
    } else {
      textString += ' ❌';
      color = Colors.red[200]!;
    }

    return Text(
      textString,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

//   Widget allGoalsDisplay(List<GoalModel>? allGoals, MyAppState appState, BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text('Goals')),
//     body: allGoals == null || allGoals.isEmpty
//         ? SizedBox(
//             height: 300,
//             width: 300,
//             child: Center(
//               child: Text("Add a goal to get started!"),
//             ),
//           )
//         : GridView.builder(
//             padding: const EdgeInsets.all(8.0),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8.0,
//               mainAxisSpacing: 8.0,
//               childAspectRatio: 2 / 1, // Keeping proper aspect ratio
//             ),
//             itemCount: allGoals.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   appState.selectedGoal = allGoals[index];
//                   appState.setSelectedPage(3);
//                 },
//                 splashColor: Colors.amber[200],
//                 child: Card(
//                   elevation: 4.0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             allGoals[index].title,
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                             allGoals[index].description,
//                             style: const TextStyle(fontSize: 14, color: Colors.amber),
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                             "Due Date: ${allGoals[index].goalEndDate.toString().split(" ")[0]}",
//                             style: const TextStyle(fontSize: 12, color: Colors.amber),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//     floatingActionButton: FloatingActionButton(
//       child: Icon(Icons.add),
//       onPressed: () {
//         appState.selectedGoal = GoalModel(
//           id: 0,
//           title: '',
//           description: '',
//           goalType: '',
//           goalEndDate: DateTime.now(),
//           isCompleted: false,
//           progress: 0,
//           priority: 1,
//           category: '',
//         );
//         appState.setSelectedPage(3);
//       },
//     ),
//   );
// }

  // Scaffold allGoalsDisplay(
  //     List<GoalModel>? allGoals, MyAppState appState, BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(title: Text('Goals')),
  //       body: allGoals == null || allGoals.isEmpty
  //           ? SizedBox(
  //               height: 300,
  //               width: 300,
  //               child: Text("Add a goal to get started!"),
  //             )
  //           : GridView.builder(
  //               padding: const EdgeInsets.all(8.0),
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 crossAxisSpacing: 8.0,
  //                 mainAxisExtent: 8.0,
  //                 childAspectRatio: 3 / 2,
  //               ),
  //               itemCount: allGoals.length,
  //               itemBuilder: (context, index) {
  //                 return Card(
  //                     color: Colors.amber,
  //                     elevation: 4.0,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             allGoals[index].title,

  //                           ),
  //                           SizedBox(height: 100.0),
  //                           Text(
  //                             allGoals[index].description,

  //                           ),
  //                           SizedBox(height: 100.0),
  //                           Text(
  //                             "Due Date: ${allGoals[index].goalEndDate.toString().split(" ")[0]}",

  //                           ),
  //                         ],
  //                       ),
  //                     ));
  //               }),
  //       floatingActionButton: FloatingActionButton(
  //           child: Icon(Icons.add),
  //           onPressed: () {
  //             appState.selectedGoal = GoalModel(
  //                 id: 0,
  //                 title: '',
  //                 description: '',
  //                 goalType: '',
  //                 goalEndDate: DateTime.now(),
  //                 isCompleted: false,
  //                 progress: 0,
  //                 priority: 1,
  //                 category: '');
  //             appState.setSelectedPage(3);

  //             //appState.db.resetDatabase().then((value) { appState.refresh(); },
  //             // appState.db.insertTestData().then((value) {
  //             //   appState.refresh();
  //             // });
  //             // appState.db.insertGoal(GoalModel.appGen('Title', 'Description', ['1,2,3'], DateTime.now(), 'Monthly'));
  //             // appState.refresh();
  //           }));
  // }
}
