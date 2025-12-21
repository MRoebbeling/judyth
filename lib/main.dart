import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  openDatabase(
    join(await getDatabasesPath(), 'judyth_memory.db'),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE judyth_task(id INTEGER PRIMARY KEY, task TEXT, status INT, parentId INT)');
      print('Hat es geklappt?');
    },
    onOpen: (db) async {
      print('DB is already created');
      //final List<Map<String, Object?>> _exercises = await db.query('exercise');
      //_exercises = await db.query('exercise');
      //print('Geladene Exercises: $_exercises');
      await db.close();
    },
    version: 1,
  );
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/judyth-background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Mainscreen(),
        ),
      ),
    );
  }
}