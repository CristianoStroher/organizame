
import 'package:organizame/app/models/task_object.dart';

class TaskWeekObject {

  final DateTime startDate;
  final DateTime endDate;
  final List<TaskObject> tasks;

  TaskWeekObject({
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });
  
}
