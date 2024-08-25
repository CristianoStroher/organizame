import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/models/task_week_object.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';

import './tasks_service.dart';

class TasksServiceImpl extends TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository tasksRepository})
      : _tasksRepository = tasksRepository;

  @override
  Future<void> saveTask(DateTime date, DateTime time, String description,
          {String? observations}) =>
      _tasksRepository.saveTask(date, time, description,
          observations: observations);

  @override
  Future<List<TaskObject>> getToday() {
    return _tasksRepository.findByPeriod(DateTime.now(), DateTime.now());
  }

  @override
  Future<List<TaskObject>> getTomorrow() {
    return _tasksRepository.findByPeriod(
        DateTime.now().add(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)));
  }

  @override
  Future<TaskWeekObject> getWeek() async {
    final today = DateTime.now();
    var startFilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;

    if (startFilter.weekday != DateTime.sunday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }

    endFilter = startFilter.add(const Duration(days: 7));

    final task = await _tasksRepository.findByPeriod(startFilter, endFilter);

    return TaskWeekObject(
        startDate: startFilter, endDate: endFilter, tasks: task);
  }
}
