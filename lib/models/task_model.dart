import 'package:goal_manager/models/task_completion.dart';

class TaskModel {
  int id; 
  String title; 
  String? description; 
  String frequency; 
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
      'frequency': frequency,
      'shouldBeRemdined': shouldBeReminded ? 1 : 0,
    };


    return map; 
  }

  factory TaskModel.fromDB(Map<String, dynamic> map, List<TaskCompletionModel> completions) {
    return TaskModel(
      id: map['id'], 
      title: map['title'], 
      description: map['description'], 
      frequency: map['frequency'], 
      shouldBeReminded: map['shouldBeReminded'] == 1,
      completions: completions
    ); 
  }



}