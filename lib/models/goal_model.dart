
import 'package:goal_manager/models/goal_metrics.dart';

class GoalModel {
  int? id;
  String title; 
  String description; 
  List<GoalMetrics>? metrics; 
  DateTime goalDate; 
  DateTime stretchDate;
  DateTime? completeDate;
  String? goalType; 

  GoalModel(this.id, this.title, this.description, this.metrics, this.goalDate, this.stretchDate, this.completeDate, this.goalType); 

  GoalModel.appGen(this.title, this.description, this.metrics, this.goalDate, this.stretchDate, this.completeDate, this.goalType);


  Map<String, Object?> toDB() { 
    
    Map<String, Object?> map = {
      'title': title, 
      'description': description,
      'goalDate': goalDate.toIso8601String(),
      'stretchDate': stretchDate.toIso8601String(), 
      'completeDate': completeDate?.toIso8601String(),
      'goalType': goalType
    }; 

    if (id != null) {
      map['id'] = id; 
    }

    return map; 
  }

}