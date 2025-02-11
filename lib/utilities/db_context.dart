import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:goal_manager/models/goal_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    CREATE TABLE Goal (id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, metrics TEXT, goalDate TEXT, goalType TEXT)
'''    );
  } 

  Future<void> insertGoal(GoalModel g) async {
    final db = await instance.database; 
    final id = await db.insert('Goal', g.toDB()); 
  }
  
  Future<List<GoalModel>> getAllGoals() async {
    final db = await instance.database; 
    final res = await db.query('Goal', orderBy: 'ID desc'); 

    return res.map((json) => GoalModel.fromDBSingle(json)).toList(); 
  }

  Future<void> updateGoal(GoalModel g) async {
    final db = await instance.database; 
    await db.update('Goal', g.toDB(), where: 'id = ?', whereArgs: [g.id]); 
  }
}
