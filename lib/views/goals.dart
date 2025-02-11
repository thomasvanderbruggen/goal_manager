import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/goal_model.dart';
import '../utilities/db_context.dart';


class GoalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    DBContext db = DBContext.instance;


    handlePress(GoalModel goal) {
       
    }

    return FutureBuilder(future: db.getAllGoals(), builder: (context, snapshot) {
      return Container(); 
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
}