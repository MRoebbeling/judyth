class MemoryModel {
  final int id;
  final String task;
  final int status;
  final int parentId;

  MemoryModel(
      {required this.id,
      required this.task,
      required this.status,
      required this.parentId});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'task': task,
      'status': status,
      'parentId': parentId
    };
  }
}