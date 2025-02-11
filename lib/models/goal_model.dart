
import 'package:flutter/material.dart';

class GoalModel {
  int? id;
  String title; 
  String description; 
  List<String> metrics; 
  DateTime goalDate; 
  String goalType; 

  GoalModel(this.id, this.title, this.description, this.metrics, this.goalDate, this.goalType); 

  Map<String, Object?> toDB() { 
    
    var metricsCSV = ''; 
    for (var m in metrics) {
      metricsCSV += '$m,'; 
    }
    metricsCSV = metricsCSV.substring(0, metricsCSV.length - 1); 
    var gdString = goalDate.toIso8601String();  
    return  {
      'id': id, 
      'title': title, 
      'description': description,
      'metrics': metricsCSV, 
      'goalDate': gdString,
      'goalType': goalType
    };
  }

  static List<GoalModel> fromDBMultiple(List<Map<String, dynamic>> dbRes) {
    List<GoalModel> out = []; 
    for (var res in dbRes){
      out.add(fromDBSingle(res)); 
    }
    return out;
  }

  static GoalModel fromDBSingle(Map<String, dynamic> dbRes) {
    var gdDT = DateTime.parse(dbRes['goalDate']); 
    var metricsList = dbRes['metrics'].split(','); 

    return GoalModel(dbRes['id'], dbRes['title'], dbRes['description'], metricsList, gdDT, dbRes['goalType']); 
  }


}