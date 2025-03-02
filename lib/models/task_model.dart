import 'package:goal_manager/models/task_completion.dart';
import 'package:goal_manager/utilities/enums.dart';

class TaskModel {
  int id; 
  String title; 
  String description; 
  Frequency frequency; 
  bool shouldBeReminded; 
  List<TaskCompletionModel> completions; 


  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.shouldBeReminded,
    required this.completions
  }); 


  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'title': title, 
      'description': description, 
      'frequency': frequency.name,
      'shouldBeReminded': shouldBeReminded ? 1 : 0,
    };


    return map; 
  }

  factory TaskModel.fromDB(Map<String, dynamic> map, List<TaskCompletionModel> completions) {
    Frequency freq = Frequency.Daily; 
    switch (map['frequency']) {
      case 'Weekly': 
        freq = Frequency.Weekly; 
      case 'Monthly': 
        freq = Frequency.Monthly; 
    }
    
    return TaskModel(
      id: map['id'], 
      title: map['title'], 
      description: map['description'], 
      frequency:  freq, 
      shouldBeReminded: map['shouldBeReminded'] == 1,
      completions: completions
    ); 
  }



}