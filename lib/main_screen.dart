//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:judyth/models/memory_model.dart';

class Mainscreen extends StatefulWidget {
  final String taskName;
  final List memoryList;
  //final List memoryList;

  const Mainscreen({
    super.key,
    required this.taskName,
    required this.memoryList,
  });

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

//List<dynamic> tmpList = widget.memoryList;

class _MainscreenState extends State<Mainscreen> {
  Future insertDB(String mem, List memoryList) async {
    if (mem != "") {
      final database = openDatabase(
        join(await getDatabasesPath(), 'judyth_memory.db'),
      );
      final db = await database;
      await db.insert('judyth_task', {
        'task': mem,
        'status': 0,
        'parentId': memoryList.last,
        'childIDs': 0,
      });
    }
    print("actual memoryList: ${memoryList.last}");
  }

  Future<List<MemoryModel>> getTaskList(List memoryList) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memoryMaps = await db.rawQuery(
      'SELECT * FROM judyth_task WHERE parentId IS (${memoryList.last})',
    );

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
            'id': id as int,
            'task': task as String,
            'status': status as int,
            'parentId': parentId as int,
            'childIDs': childIDs as int,
          }
          in memoryMaps)
        MemoryModel(
          id: id,
          task: task,
          status: status,
          parentId: parentId,
          childIDs: childIDs,
        ),
    ];
  }

  Future changeMemmoryStatus(int mem) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;

    List<Map<String, Object?>> tempstatus = await db.rawQuery(
      'SELECT status FROM judyth_task WHERE id = ?',
      [mem],
    );

    if (tempstatus[0]['status'] == 0) {
      await db.update(
        'judyth_task',
        {'status': 1},
        where: 'id = ?',
        whereArgs: [mem],
      );
    } else if (tempstatus[0]['status'] == 1) {
      await db.delete('judyth_task', where: 'id = ?', whereArgs: [mem]);
    }
  }

  Future changeChildStatus(int mem, int childstate) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;

    //List<Map<String, Object?>> tempstatus = await db.rawQuery('SELECT status FROM judyth_task WHERE id = ?', [mem]);
    if (childstate == 1) {
      await db.update(
        'judyth_task',
        {'childIDs': 1},
        where: 'id = ?',
        whereArgs: [mem],
      );
    } else {
      await db.update(
        'judyth_task',
        {'childIDs': 0},
        where: 'id = ?',
        whereArgs: [mem],
      );
    }
  }

  Future setParentId(int mem, int parent) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;
    await db.update(
      'judyth_task',
      {'parentId': parent},
      where: 'id = ?',
      whereArgs: [mem],
    );
    print("Versuch parentID zu äbndert $mem zu $parent");
  }

  Future<bool> isParent(int mem) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;

    List<Map<String, Object?>> tempParent = await db.rawQuery(
      'SELECT * FROM judyth_task WHERE parentId = ?',
      [mem],
    );
    print("Parent Liste: $tempParent");
    if (tempParent.isNotEmpty) {
      print("Return true");
      return true;
    } else {
      print("Return false");
      return false;
    }
  }

  void zuruckCheck(int mem) async {
    //Check if there is a task in the current level and set the child state for the receiving parent

    final database = openDatabase(
      join(await getDatabasesPath(), 'judyth_memory.db'),
    );
    final db = await database;

    List<Map<String, Object?>> tempParent = await db.rawQuery(
      'SELECT * FROM judyth_task WHERE parentId = ?',
      [mem],
    );
    //print("Parent Liste: $tempParent");
    if (tempParent.isNotEmpty) {
      // Heist das ein task in der childliste ist, also muss der parent task ein child von 1 bekommen
      changeChildStatus(mem, 1);

      print("TaskID: $mem Return true");
    } else {
      changeChildStatus(mem, 0);
      print("TaskID: $mem Return false");
    }
    setState(() {
      //_textinput = _textcontroler.text;
      print('List middle = : ${widget.memoryList.length}');
    });
  }

  final _textcontroler = TextEditingController();

  List<dynamic> tmpList = [];
  /*void initState() {
    super.initState();
    //initialization();
    print("Start"); 
    //List<dynamic> tmplist = widget.memoryList;
    //print("TMP MemoryList: $tmplist");
  }*/

  @override
  Widget build(BuildContext context) {
    //tmpList = List.from(widget.memoryList);
    //tmpList.add(snapshot.data![index].id);
    //print('TMP-List at start = : ${widget.memoryList}');

    //print("MemoryList: $widget.memoryList");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 192, 192, 192),
          elevation: 0,
          centerTitle: false,
          leading: (widget.memoryList.length > 1)
              ? InkWell(
                  //Falls die memoryList mehr als ein Element hat, zeige den Zurück-Button an
                  onTap: () {
                    zuruckCheck(widget.memoryList.last);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.navigate_before,
                    color: Color.fromARGB(255, 9, 7, 7),
                  ),
                )
              : null, //Sonnst, kein Zurückbotton (NULL)
          title: Text(
            "Todo: ${widget.taskName}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Padding (padding: EdgeInsets.only(left: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*InkWell(
                        onTap: () {
                          
                          Navigator.pop(context);
                          setState(() {
                            //_textinput = _textcontroler.text;
                            print('List middle = : ${widget.memoryList.length}'); 
                          });
                        },
                        child: Icon(
                          (widget.memoryList.length > 1) ? Icons.navigate_before : Icons.error_outline,
                          color: Color.fromARGB(255, 9, 7, 7),
                          size: 30,
                        ),
                      ),*/

                      Text (
                        "Todo: ${widget.taskName}",
                        style: TextStyle(
                        fontSize: 24,
                         fontWeight: FontWeight.bold,
                         color: Colors.black
                        ),
                      )
                      
                    ],
                  ),
              ),  */

                /* Abstandshalter Titel Liste */
                SizedBox(height: 20, width: double.infinity),

                /* Liste mit tasks */
                FutureBuilder<List<dynamic>>(
                  future: getTaskList(widget.memoryList),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot,
                      ) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            /*Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('The result...${snapshot.data}'),
                            ),*/
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    color: const Color.fromARGB(0, 5, 148, 244),
                                    elevation: 0,
                                    shape: Border(
                                      bottom: BorderSide(
                                        color: const Color.fromARGB(
                                          120,
                                          212,
                                          212,
                                          212,
                                        ),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      /* 
                                          Leading Icon zum Abhaken der Tasks
                                          */
                                      leading: InkWell(
                                        onTap: () {
                                          changeMemmoryStatus(
                                            snapshot.data![index].id,
                                          );
                                          setState(() {
                                            //_textinput = _textcontroler.text;
                                          });
                                        },
                                        child: Icon(
                                          (snapshot.data![index].status == 0)
                                              ? Icons.radio_button_unchecked
                                              : Icons.error_outline,
                                          color: Color.fromARGB(255, 9, 7, 7),
                                          size: 30,
                                        ),
                                      ),

                                      /* 
                                          TaskText
                                          */
                                      title: Text(
                                        snapshot.data![index].task,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),

                                      /*
                                          EndIcon zum weitergehen in die Untertasks
                                          */
                                      trailing: InkWell(
                                        onTap: () {
                                          setParentId(
                                            snapshot.data![index].id,
                                            widget.memoryList.last,
                                          );

                                          //widget.memoryList.add(snapshot.data![index].id);
                                          tmpList = List.from(
                                            widget.memoryList,
                                          );
                                          tmpList.add(snapshot.data![index].id);
                                          print('TMP-List = : $tmpList');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Mainscreen(
                                                taskName:
                                                    snapshot.data![index].task,
                                                memoryList: tmpList,
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            //_textinput = _textcontroler.text;
                                          });
                                        },
                                        child:
                                            (snapshot.data![index].childIDs !=
                                                0)
                                            ? Icon(
                                                Icons.arrow_circle_right,
                                                color: Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.arrow_circle_right,
                                                color: Color.fromARGB(
                                                  255,
                                                  191,
                                                  191,
                                                  191,
                                                ),
                                                size: 30,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[
                            const Icon(
                              Icons.error_outline,
                              color: Color.fromARGB(255, 153, 255, 0),
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text('Error: ${snapshot.error}'),
                            ),
                          ];
                        } else {
                          children = const <Widget>[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            ),
                          ];
                        }
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: children,
                          ),
                        );
                      },
                ),

                /*

                Untere Eingabe der Tasks

                */
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(132, 180, 180, 180),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: _textcontroler,
                          decoration: const InputDecoration(
                            hintText: 'Enter item to remember',
                            hintStyle: TextStyle(
                              fontSize: 20.0,
                              color: Color(0X66000000),
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),

                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color(0xFF000000),
                          ),
                          onSubmitted: (value) {
                            insertDB(_textcontroler.text, widget.memoryList);
                            setState(() {
                              //_textinput =
                              _textcontroler.clear();
                            });
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          insertDB(_textcontroler.text, widget.memoryList);
                          setState(() {
                            //_textinput =
                            _textcontroler.clear();
                          });
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
