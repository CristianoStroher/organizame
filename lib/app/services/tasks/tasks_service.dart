import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/models/task_week_object.dart';

abstract class TasksService {
    
    Future<void> saveTask(DateTime date, DateTime time, String description, {String? observations});
    Future<List<TaskObject>> getToday();
    Future<List<TaskObject>> getTomorrow();
    Future<TaskWeekObject> getWeek();
    Future<bool> deleteTask(TaskObject task);
    Future<TaskObject?> findTask(TaskObject task);
    Future<void> finishTask(TaskObject task);
    Future<void> updateTask(TaskObject task);
    Future<List<TaskObject>> getOldTasks({DateTime? startDate, DateTime? endDate});

   

 

}