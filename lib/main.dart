import 'package:flutter/material.dart';
import 'package:judyth/main_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*openDatabase(
    join(await getDatabasesPath(), 'judyth_memory.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE judyth_task(id INTEGER PRIMARY KEY, task TEXT, status INT, parentId INT, childIDs INT)',
      );
      print('Hat es geklappt?');
    },
    onOpen: (db) async {
      print('DB is already created');

      //final List<Map<String, Object?>> _exercises = rawait db.query('exercise');
      //_exercises = await db.query('exercise');
      //print('Geladene Exercises: $_exercises');
      await db.close();
    },
    version: 1,
  );*/
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    //initialization();
  }

  /*void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }*/

  //String taskName = 'Daily Tasks';

  @override
  Widget build(BuildContext context) {
    /*void openMainScreen() {
    
      Navigator.push(context, MaterialPageRoute(
            builder: (context) => const Mainscreen(
            taskName: 'Daily Tasks', 
            memoryList: [0],
          ),
        ),
      );
    }*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
          ),
          child: const Mainscreen(taskName: "Daily Task", memoryList: [0]),
        ),
      ),
    );
  }
}
