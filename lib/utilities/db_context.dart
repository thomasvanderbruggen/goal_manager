import 'dart:async';
import 'package:goal_manager/models/task_completion.dart';
import 'package:goal_manager/models/task_model.dart';
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

CREATE TABLE Tasks (
    id INTEGER PRIMARY KEY, 
    title TEXT, 
    description TEXT,
    frequency TEXT, 
    shouldBeReminded INTEGER
); 

CREATE TABLE TaskCompletion (
    id INTEGER PRIMARY KEY, 
    taskId INTEGER, 
    completedDate TEXT,
    description TEXT
); 


'''    );
  } 

  // Should only be used in Dev
  Future<void> resetDatabase() async {
    final db = await instance.database; 

    await db.execute('DROP TABLE IF EXISTS GoalMetrics'); 
    await db.execute('DROP TABLE IF EXISTS Goal'); 
    await db.execute('DROP TABLE IF EXISTS Tasks'); 
    await db.execute('DROP TABLE IF EXISTS TaskCompletion'); 

    await _initalizeDB(); 


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

  Future<int> insertTaskCompletion(TaskCompletionModel tcm) async {
    int tcmID = 0; 

    if (tcm.id > 0) { 
      await updateTaskCompletion(tcm); 
      tcmID = tcm.id; 
    }else {
      final db = await instance.database; 
      tcmID = await db.insert('TaskCompletion', tcm.toDB(), conflictAlgorithm: ConflictAlgorithm.replace); 
    }

    return tcmID; 
  }

  Future<void> updateTaskCompletion(tcm) async { 
    final db = await instance.database; 
    await db.update('TaskCompletion', tcm.toDB(), where: 'id = ?', whereArgs: [tcm.id]);
  }


  Future<void> updateTask(TaskModel t) async {
    final db = await instance.database; 
    List<Future> taskCompletionsFutures = [db.update('Goal', t.toDB(), where: 'id = ?', whereArgs: [t.id])]; 

    for (TaskCompletionModel tcm in t.completions) { 
      taskCompletionsFutures.add(insertTaskCompletion(tcm)); 
    }

    await Future.wait(taskCompletionsFutures); 
  }

  Future<int> insertTask(TaskModel t) async { 
    int taskId = 0; 

    if (t.id > 0) {
      await updateTask(t); 
      taskId = t.id; 
    }else { 
      final db = await instance.database; 
      taskId = await db.insert('Tasks', t.toDB(), conflictAlgorithm: ConflictAlgorithm.replace); 
    }

    return taskId; 
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await instance.database; 
    final taskRes =  db.query('Tasks', orderBy: 'ID desc');
    final taskCompletionRes = db.query('TaskCompletion', orderBy: 'taskId asc, ID desc', where: 'completedDate LIKE ?', whereArgs: ['%${DateTime.now().year}%']); 

    var responses = await Future.wait([taskRes, taskCompletionRes]);

    var tasks = responses[0]; 
    var taskCompletions = responses[1]; 

    Map<int, List<TaskCompletionModel>> taskCompletionsDict = {};

    // Loop over the List<Map> response from db and create TaskCompletions 
    taskCompletions.forEach((taskCompletion) { 
      TaskCompletionModel temp = TaskCompletionModel.fromDB(taskCompletion);
      taskCompletionsDict.containsKey(temp.taskId) ? taskCompletionsDict[temp.taskId]!.add(temp) :  taskCompletionsDict[temp.taskId] = [temp]; 
    }); 
    
    List<TaskModel> taskList =  []; 
    // Loop over the List<Map> response from db and create Tasks, if taskCompletions exist for task, add them to task otherwise add empty list
    tasks.forEach((task) {
      TaskModel temp = TaskModel.fromDB(task, taskCompletionsDict.containsKey(task['id']) ? taskCompletionsDict[task['id']]! : []); 
      taskList.add(temp);  
    });

    return taskList; 
  }



}
