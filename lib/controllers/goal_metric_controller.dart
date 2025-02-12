import 'package:goal_manager/models/goal_metrics.dart';

class GoalMetricsController {
  static GoalMetrics buildFromDB(Map<String, dynamic?> dbRes) {

    var a = dbRes['goalId']; 
    return GoalMetrics(dbRes['id'], dbRes['goalId'], dbRes['title'],
        dbRes['description'], dbRes['percentCompleted']);
  }
}
