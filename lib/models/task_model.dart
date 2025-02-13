class TaskModel {
  int? id; 
  String title; 
  String? description; 
  String frequency; 
  bool shouldBeReminded; 


  TaskModel(this.id, this.title, this.description, this.frequency, this.shouldBeReminded); 

  TaskModel.appGen(this.title, this.description, this.frequency, this.shouldBeReminded); 

  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'title': title, 
      'description': description, 
      'frequency': frequency,
      'shouldBeRemdined': shouldBeReminded ? 1 : 0,
    };

    if (id != null) {
      map['id'] = id; 
    }
    return map; 
  }



}