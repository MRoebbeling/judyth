import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:judyth/models/memory_model.dart';

Future insertDB(String mem, List memoryList) async {
  /*

insertBD insertrts the Task into the Database

mem: The String that is entered into the Database
memoryList: List to dertemine the Parent ID

*/
  if (mem != "") {
    final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
    final db = await database;
    await db.insert('judyth_task', {'task': mem, 'status': 0, 'parentId': memoryList.last, 'childIDs': 0});
  }
  //print("actual memoryList: ${memoryList.last}");
}

/*-----------------------------------------------------------------------------*/

Future<List<MemoryModel>> getTaskList(List memoryList) async {
  /*

getTasklList retrieves the list of tasks from the database based on the current memoryList

The return is of type MemoryModel

*/

  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;

  final List<Map<String, Object?>> memoryMaps = await db.rawQuery(
    'SELECT * FROM judyth_task WHERE parentId IS (${memoryList.last})',
  );

  return [
    for (final {
          'id': id as int,
          'task': task as String,
          'status': status as int,
          'parentId': parentId as int,
          'childIDs': childIDs as int,
        }
        in memoryMaps)
      MemoryModel(id: id, task: task, status: status, parentId: parentId, childIDs: childIDs),
  ];
}

/*-----------------------------------------------------------------------------*/

Future changeMemmoryStatus(int mem) async {
  /*

changeMemorzStatus changes the status of a task based on its current status and childIDs

mem: The ID of the task to change

If there is NO child attached to the atsk, a click on the status-icon changes
the status from 0 to 1 or deletes the task if the status is already 1.

If there is a child attached to the task, a click on the status-icon does nothing.Status is just
coming from the child.

*/
  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;

  List<Map<String, Object?>> tempstatus = await db.rawQuery('SELECT status, childIDs FROM judyth_task WHERE id = ?', [
    mem,
  ]);

  if (tempstatus[0]['childIDs'] != 0) {
    //print('Ist schon belegt: ${tempstatus[0]['childIDs']}');
  } else {
    if (tempstatus[0]['status'] == 0) {
      //print("Status is 0, change to 1");
      await db.update('judyth_task', {'status': 1}, where: 'id = ?', whereArgs: [mem]);
    } else if (tempstatus[0]['status'] == 1) {
      await db.delete('judyth_task', where: 'id = ?', whereArgs: [mem]);
    }
  }
}

/*-----------------------------------------------------------------------------*/

Future changeChildStatus(int mem, int childstate) async {
  /*

changeChildStatus changes the childID status of a task based on its current childstate

mem: ID of the task to change
childstate: New state of the childID (0 or 1)

*/
  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;

  //List<Map<String, Object?>> tempstatus = await db.rawQuery('SELECT status FROM judyth_task WHERE id = ?', [mem]);
  if (childstate == 1) {
    await db.update('judyth_task', {'childIDs': 1}, where: 'id = ?', whereArgs: [mem]);
  } else {
    await db.update('judyth_task', {'childIDs': 0}, where: 'id = ?', whereArgs: [mem]);
  }
}

/*-----------------------------------------------------------------------------*/

Future setParentId(int mem, int parent) async {
  /*

setParentID: Sets the parentID of a task
mem: ID of the task to change
parent: New parentID

*/
  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;
  await db.update('judyth_task', {'parentId': parent}, where: 'id = ?', whereArgs: [mem]);
  //print("Versuch parentID zu äbndert $mem zu $parent");
}

/*-----------------------------------------------------------------------------*/

Future changeParentStatus(int parent, int status) async {
  /*

changeParentStatus: Changes the status of a parent task based on the status of its children
parent: ID of the parent task
status: New status to set (0 or 1)

*/
  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;
  //print('Der Typ des Status ${status.runtimeType}');
  if (status == 1) {
    await db.update('judyth_task', {'status': 1}, where: 'id = ?', whereArgs: [parent]);
  } else {
    await db.update('judyth_task', {'status': 0}, where: 'id = ?', whereArgs: [parent]);
  }
}

/*-----------------------------------------------------------------------------*/

Future<bool> isParent(int mem) async {
  /*

isParent: Checks if a task has children
mem: ID of the task to check
Returns true if the task has children, false otherwise

*/

  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;

  List<Map<String, Object?>> tempParent = await db.rawQuery('SELECT * FROM judyth_task WHERE parentId = ?', [mem]);
  //print("Parent Liste: $tempParent");
  if (tempParent.isNotEmpty) {
    //print("Return true");
    return true;
  } else {
    //print("Return false");
    return false;
  }
}

/*-----------------------------------------------------------------------------*/

dynamic zuruckCheck(int mem) async {
  /*

zuruckCheck: Checks if a task has children and updates the parent and child statuses accordingly
mem: ID of the task to check
Returns 1 after updating statuses

*/

  final database = openDatabase(join(await getDatabasesPath(), 'judyth_memory.db'));
  final db = await database;

  List<Map<String, Object?>> tempParent = await db.rawQuery('SELECT * FROM judyth_task WHERE parentId = ?', [mem]);
  //print("Parent Liste: $tempParent");
  if (tempParent.isNotEmpty) {
    // Heist das ein task in der childliste ist, also muss der parent task ein child von 1 bekommen
    changeChildStatus(mem, 1);

    // Checken ob in einem der Children der Status 1 ist
    //print('Anzahl der Elemente in der Liste: ${tempParent.length} : ${tempParent}');
    int tempstatus = 0;
    for (var i = 0; i < tempParent.length; i++) {
      if (tempParent[i]['status'] == 1) {
        tempstatus = 1;
      }
    }
    if (tempstatus == 1) {
      changeParentStatus(mem, 1);
    } else {
      changeParentStatus(mem, 0);
    }

    //print("TaskID: $mem Return true");
  } else {
    changeChildStatus(mem, 0);
    //print("TaskID: $mem Return false");
  }
  return 1;
}
