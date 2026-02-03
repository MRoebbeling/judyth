import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:judyth/models/memory_model.dart';
import 'package:judyth/db_methods.dart';
import 'package:judyth/models/color_palettes.dart';

class Mainscreen extends StatefulWidget {
  final String taskName;
  final List memoryList;
  //final List memoryList;

  const Mainscreen({super.key, required this.taskName, required this.memoryList});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

//List<dynamic> tmpList = widget.memoryList;

class _MainscreenState extends State<Mainscreen> {
  void _showTextInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to push up with the keyboard
      builder: (context) {
        return Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Key for keyboard padding
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add new Category:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(CupertinoIcons.house, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.person_crop_circle, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.tree, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.bell, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.tortoise, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.rocket, size: 30, color: Colors.grey),
                    Icon(CupertinoIcons.phone, size: 30, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _textcontroler,
                  autofocus: true, // Opens keyboard automatically
                  decoration: InputDecoration(
                    hintText: 'Type something...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle the submission logic here
                        await insertDB(_textcontroler.text, widget.memoryList);
                        setState(() {
                          _textcontroler.clear();
                          myTaskList = getTaskList(widget.memoryList);
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  final _textcontroler = TextEditingController();

  List<dynamic> tmpList = [];

  int colorCode = 2;

  late Future<List<dynamic>> myTaskList;
  late Future<Map<int, ColorPalette>> myColor;

  @override
  void initState() {
    super.initState();
    myTaskList = getTaskList(widget.memoryList);
    myColor = loadColorPalettes();
    //print(myColor[1].color[1][2]);
  }

  Widget build(BuildContext context) {
    //tmpList = List.from(widget.memoryList);
    //tmpList.add(snapshot.data![index].id);
    //print('TMP-List at start = : ${widget.memoryList}');

    //print("MemoryList: $widget.memoryList");

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/judyth-background-ml.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
          leading: (widget.memoryList.length > 1)
              ? InkWell(
                  //Falls die memoryList mehr als ein Element hat, zeige den Zurück-Button an
                  onTap: () async {
                    await zuruckCheck(widget.memoryList.last);
                    setState(() {
                      myTaskList = getTaskList(widget.memoryList);
                    });
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.navigate_before, color: Color.fromARGB(255, 9, 7, 7)),
                )
              : null, //Sonnst, kein Zurückbotton (NULL)
          title: Text(
            "Todo: ${widget.taskName}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: const Color.fromARGB(255, 114, 114, 114)),
                child: Text('Judyth Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('color1'),
                onTap: () {
                  // Handle Home tap
                  setState(() {
                    colorCode = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('color1'),
                onTap: () {
                  // Handle Home tap
                  setState(() {
                    colorCode = 3;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('color2'),
                onTap: () {
                  // Handle Settings tap
                  setState(() {
                    colorCode = 4;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/judyth-background-ml.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<dynamic>>(
                  future: Future.wait([myTaskList, myColor]),
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      Map<int, ColorPalette> colors = snapshot.data![1];
                      children = <Widget>[
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data?[0].length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: Color.fromARGB(
                                colors[colorCode]!.color[index][0],
                                colors[colorCode]!.color[index][1],
                                colors[colorCode]!.color[index][2],
                                colors[colorCode]!.color[index][3],
                              ),
                              elevation: 0,
                              shape: Border(
                                bottom: BorderSide(color: const Color.fromARGB(120, 212, 212, 212), width: 1.0),
                              ),
                              child: ListTile(
                                /* 
                                  Leading Icon zum Abhaken der Tasks
                                  */
                                leading: InkWell(
                                  onTap: () async {
                                    await changeMemmoryStatus(snapshot.data![0][index].id);
                                    setState(() {
                                      myTaskList = getTaskList(widget.memoryList);
                                    });
                                  },
                                  child: Icon(
                                    (snapshot.data![0][index].status == 0)
                                        ? CupertinoIcons.square
                                        : CupertinoIcons.minus_square,
                                    color: Color.fromARGB(255, 9, 7, 7),
                                    size: 30,
                                  ),
                                ),

                                /* 
                                  TaskText
                                  */
                                title: Text(
                                  snapshot.data![0][index].task,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 150, 149, 149),
                                  ),
                                ),

                                /*
                                  EndIcon zum weitergehen in die Untertasks
                                  */
                                trailing: InkWell(
                                  onTap: () async {
                                    setParentId(snapshot.data![0][index].id, widget.memoryList.last);

                                    //widget.memoryList.add(snapshot.data![index].id);
                                    tmpList = List.from(widget.memoryList);
                                    tmpList.add(snapshot.data![0][index].id);
                                    //print('TMP-List = : $tmpList');

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Mainscreen(taskName: snapshot.data![0][index].task, memoryList: tmpList),
                                      ),
                                    ).then((_) {
                                      print(snapshot.data![0][index].childIDs);
                                      setState(() {
                                        myTaskList = getTaskList(widget.memoryList);
                                      });
                                      print("The State is set");
                                    });
                                  },
                                  child: (snapshot.data![0][index].childIDs != 0)
                                      ? Icon(Icons.arrow_circle_right, color: Color.fromARGB(255, 0, 0, 0), size: 30)
                                      : Icon(
                                          Icons.arrow_circle_right,
                                          color: Color.fromARGB(255, 191, 191, 191),
                                          size: 30,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Icon(Icons.error_outline, color: Color.fromARGB(255, 153, 255, 0), size: 60),
                        Padding(padding: const EdgeInsets.only(top: 16), child: Text('Error: ${snapshot.error}')),
                      ];
                    } else {
                      children = const <Widget>[
                        SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
                        Padding(padding: EdgeInsets.only(top: 16), child: Text('Awaiting result...')),
                      ];
                    }
                    return Column(mainAxisAlignment: MainAxisAlignment.start, children: children);
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Action for the button
            _showTextInput(context);
          },
          shape: const CircleBorder(side: BorderSide(color: Color.fromARGB(255, 200, 200, 200), width: 2)),
          mini: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,

          child: Icon(Icons.add, size: 30, color: Color.fromARGB(255, 80, 80, 80)),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        /*bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 255, 255, 255),
            //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Color.fromARGB(255, 111, 111, 111)),
                onPressed: () {
                  // Home action
                },
              ),
              SizedBox(width: 40), // Space for the FAB
              IconButton(
                icon: Icon(Icons.settings, color: Color.fromARGB(255, 111, 111, 111)),
                onPressed: () {
                  // Settings action
                },
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}
