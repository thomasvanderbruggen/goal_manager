class TaskCompletionModel {
  int id;
  int taskId; 
  DateTime completedDate; 
  String description; 

  TaskCompletionModel({
    required this.id,
    required this.taskId,
    required this.completedDate,
    required this.description}); 


  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'taskId': taskId, 
      'completedDate': completedDate.toIso8601String(), 
      'description': description, 
    }; 

    return map; 
  }

  factory TaskCompletionModel.fromDB(Map<String, dynamic> map) {
    return TaskCompletionModel(
      id: map['id'], 
      taskId: map['taskId'], 
      completedDate: DateTime.parse(map['completedDate']), 
      description: map['description']
    ); 
  }
}