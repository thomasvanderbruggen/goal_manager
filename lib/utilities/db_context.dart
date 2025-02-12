import 'dart:async';
import 'package:goal_manager/controllers/goal_metric_controller.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import 'db_context_queries.dart'; 

import '../models/goal_metrics.dart';

class DBContext {
  DBContext._init(); 

  static final DBContext instance = DBContext._init(); 

  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!; 
    db = await _initalizeDB(); 
    return db!; 
  }

  Future<Database> _initalizeDB() async {
    final dbPath = await getDatabasesPath(); 
    final path = join(dbPath, 'goal_manager.db'); 
    return await openDatabase(path, version: 1, onCreate: _onCreate); 
  }

  Future _onCreate(Database db, int version) async {
    return await db.execute('''
    CREATE TABLE Goal (id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, metrics TEXT, goalDate TEXT, goalType TEXT); 
    INSERT INTO Goal (title, description, metrics, goalDate, goalType) 
    VALUES ('Goal 1', 'Desc 1', 'Metric1,Metric2,Metric3', '2025-02-10T23:24:56+0000', 'Monthly'), ('Goal 2', 'Desc 2', 'Metric1,Metric2,Metric3', '2025-02-10T23:24:56+0000', 'Monthly'), ('Goal 3', 'Desc 3', 'Metric1,Metric2,Metric3', '2025-02-10T23:24:56+0000', 'Monthly')
'''    );
  } 

  // Should only be used in Dev
  Future<void> resetDatabase() async {
    final db = await instance.database; 

    await db.execute('DROP TABLE IF EXISTS GoalMetrics'); 
    await db.execute('DROP TABLE IF EXISTS Goal'); 

    await db.execute(createGoal); 
    await db.execute(createGoalMetrics); 

    await db.execute(insertTestGoal); 

    await db.execute(insertTestGoalMetric); 
    
  }

  Future<int> insertTestData() async {
    final db = await instance.database; 
    await db.execute(insertTestGoal); 
    await db.execute(insertTestGoalMetric); 

    return 200; 
  }

  Future<int> insertGoal(GoalModel g) async {
    final db = await instance.database; 
    return await db.insert('Goal', g.toDB()); 
  }
  
  Future<List<GoalModel>> getAllGoals() async {
    final db = await instance.database;
    final res = await db.query('Goal', orderBy: 'ID asc'); 
    final res1 = await db.query('GoalMetrics', orderBy: 'ID desc'); 

    // Get Goals and Metrics from DB
    // Build Metrics
    // ---Get list of metrics per Goal, then send to GoalController to build
    Map<int, List<GoalMetrics>> metrics = { 

    }; 

    for (var metric in res1) {
      GoalMetrics gm = GoalMetricsController.buildFromDB(metric); 
      if (!metrics.keys.contains(gm.goalId)) {
        metrics[gm.goalId!] = []; 
      }
      metrics[gm.goalId!]!.add(gm); 
    }

    List<GoalModel> goals = []; 

    for (var goal in res) {
      goals.add(GoalController.buildGoalModel(goal, metrics[goal['id']])); 
    }

    return goals;
  }

  Future<void> updateGoal(GoalModel g) async {
    final db = await instance.database; 
    await db.update('Goal', g.toDB(), where: 'id = ?', whereArgs: [g.id]); 
  }

  Future<void> deleteGoal(GoalModel g) async {
    final db = await instance.database;
    await db.delete('Goal', where: 'id = ?', whereArgs: [g.id]); 
  }

  Future<int> insertGoalMetric(GoalMetrics gm) async {
    final db = await instance.database;

    if ((await db.query('Goal', where: 'id = ?', whereArgs: [gm.goalId])).isEmpty) {
      throw Exception("Metrics failed to insert because Goal has not been inserted"); 
    }

    return await db.insert('GoalMetric', gm.toDB());
  }

  Future<List<Map<String, Object?>>> getAllMetrics() async {
    final db = await instance.database; 

    return await db.query('GoalMetric', orderBy: 'ID desc'); 
  }

  Future<List<Map<String, Object?>>> getAllMetricsPerGoal(int goalId) async {
    final db = await instance.database; 

    return await db.query('GoalMetric', where: 'goalId = ?', whereArgs: [goalId]); 
  }

}
