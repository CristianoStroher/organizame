import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/models/task_week_object.dart';

abstract class TasksService {
    
    Future<void> saveTask(DateTime date, DateTime time, String description, {String? observations});
    Future<List<TaskObject>> getToday();
    Future<List<TaskObject>> getTomorrow();
    Future<TaskWeekObject> getWeek();
    Future<void> deleteTask(TaskObject task);

}