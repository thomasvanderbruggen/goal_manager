import '../models/goal_metrics.dart';
import '../models/goal_model.dart';

class GoalController {
  static GoalModel buildGoalModel(
      Map<String, dynamic> goalFromDB, List<GoalMetrics>? metrics) {
    GoalModel g;

    if (goalFromDB['completeDate'] == null) {
      g = GoalModel(
          goalFromDB['id'],
          goalFromDB['title'],
          goalFromDB['description'],
          metrics,
          DateTime.parse(goalFromDB['goalDate']),
          DateTime.parse(goalFromDB['stretchDate']),
          null,
          goalFromDB['goalType']);
    } else {
      g = GoalModel(
          goalFromDB['id'],
          goalFromDB['title'],
          goalFromDB['description'],
          metrics,
          DateTime.parse(goalFromDB['goalDate']),
          DateTime.parse(goalFromDB['stretchDate']),
          DateTime.tryParse(goalFromDB['completeDate']),
          goalFromDB['goalType']);
    }
    return g;
  }
}
