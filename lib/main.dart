import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'models/goal_model.dart';
import 'models/task_model.dart';
import 'views/all.dart';
import 'utilities/db_context.dart';
import 'views/tasks/task_form.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "W I P",
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.amber,
            dialogBackgroundColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,                       
            useMaterial3: true),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPage = 0;
  var selectedIndex = 0;
  DBContext db = DBContext.instance;
  late GoalModel selectedGoal;
  late TaskModel selectedTask; 
  void setSelectedPage(int page) {
    selectedPage = page;
    var tempIdx = page; 
    if (page == 0) tempIdx = 1;
    if (page == 1 || page == 4) tempIdx = 0; 
    if (page == 3) tempIdx = 2;
    selectedIndex = tempIdx;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var selectedIndex = appState.selectedIndex; 
    var selectedPage = appState.selectedPage; 

    Widget page;
    switch (selectedPage) {
      case 0:
        page = DefaultPage();
      case 1:
        page = TasksPage();
      case 2:
        page = GoalsPage();
      case 3:
        page = GoalDetailed();
      case 4: 
        page = TaskForm(); 
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: page, 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              var tempIdx = index; 
              if (index == 0) tempIdx = 1;
              if (index == 1) tempIdx = 0; 

              index = tempIdx;  
              appState.setSelectedPage(index); 
            }); 
          }, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_score), label: 'Goals'),
        ],
        ),
      ); 
    }); 
  }
}
