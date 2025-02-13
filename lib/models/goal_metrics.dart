class GoalMetrics {
  int? id; 
  int? goalId; 
  String title;
  String description; 
  int percentCompleted;

  GoalMetrics(this.id, this.goalId, this.title, this.description, this.percentCompleted); 

  GoalMetrics.appGen(this.title,  this.description, this.percentCompleted); 

  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'goalId': goalId, 
      'description': description, 
      'percentCompleted': percentCompleted
    }; 

    if (id != null) {
      map['id'] = id; 
    }

    return map; 
  }

}