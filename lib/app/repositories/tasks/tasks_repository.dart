import 'package:organizame/app/models/task_object.dart';

abstract class TasksRepository {
  
  Future<void> saveTask(DateTime date, DateTime time, String description,
      {String? observations});
  Future<List<TaskObject>> findByPeriod(DateTime start, DateTime end);
  Future<bool> deleteTask(TaskObject task);
  Future<void> updateTask(TaskObject task);
  Future<TaskObject?> findTask(TaskObject task);
  Future<void> finishTask(TaskObject task);
}
