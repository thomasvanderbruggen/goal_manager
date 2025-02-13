class TaskCompletion {
  int? id;
  int taskId; 
  DateTime completedDate; 
  String? description; 

  TaskCompletion(this.id, this.taskId, this.completedDate, this.description); 

  TaskCompletion.appGen(this.taskId, this.completedDate, this.description); 

  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'taskId': taskId, 
      'completedDate': completedDate.toIso8601String(), 
      'description': description
    }; 

    if (id != null) {
      map['id'] = id; 
    }
    return map; 
  }
}