class GoalModel {
  int id;
  String title;
  String description;
  String goalType;
  DateTime goalEndDate;
  bool isCompleted;
  int  progress;
  int priority;
  String category;

  GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.goalType,
    required this.goalEndDate,
    required this.isCompleted,
    required this.progress,
    required this.priority,
    required this.category,
  });

  Map<String, Object?> toDB() {
    final map = {
      'title': title,
      'description': description,
      'goalType': goalType,
      'goalEndDate': goalEndDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'progress': progress,
      'priority': priority,
      'category': category,
    };
    
    if (id > 0) {
      map['id'] = id;
    }
    
    return map;
  }

  factory GoalModel.fromDB(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      goalType: map['goalType'],
      goalEndDate: DateTime.parse(map['goalEndDate']),
      isCompleted: map['isCompleted'] == 1,
      progress: map['progress'],
      priority: map['priority'],
      category: map['category'],
    );
  }
}
