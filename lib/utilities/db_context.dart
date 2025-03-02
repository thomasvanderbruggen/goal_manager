import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/goal_model.dart';
import 'db_context_queries.dart'; 

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
    CREATE TABLE Goal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    goalType TEXT NOT NULL,
    goalEndDate TEXT NOT NULL,
    isCompleted INTEGER NOT NULL CHECK (isCompleted IN (0,1)),
    progress INTEGER NOT NULL,
    priority INTEGER NOT NULL,
    category TEXT NOT NULL
); 

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
    int goalId = 0; 

    if (g.id > 0) {
      await updateGoal(g);
      goalId = g.id;  
    }else {
      final db = await instance.database; 
      goalId = await db.insert('Goal', g.toDB(), conflictAlgorithm: ConflictAlgorithm.replace);  
    }

    return goalId; 
  }
  
  Future<List<GoalModel>> getAllGoals() async {
    final db = await instance.database;
    final res = await db.query('Goal', orderBy: 'ID asc'); 

    List<GoalModel> goals = []; 
    res.forEach((goal) {
      goals.add(GoalModel.fromDB(goal)); 
    }); 

    return goals;
  }

  Future<void> updateGoal(GoalModel g) async {
    final db = await instance.database; 
    await db.update('Goal', g.toDB(), where: 'id = ?', whereArgs: [g.id]); 
  }

  Future<void> deleteGoal(GoalModel g) async {
    final db = await instance.database;
    await db.delete('GoalMetrics', where: 'goalId = ?', whereArgs: [g.id]); 
    await db.delete('Goal', where: 'id = ?', whereArgs: [g.id]); 
  }

}
