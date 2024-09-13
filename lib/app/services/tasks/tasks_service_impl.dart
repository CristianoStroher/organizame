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
  
  @override
  Future<bool> deleteTask(TaskObject task) async {
    return _tasksRepository.deleteTask(task);  
  }
  
  @override
  Future<TaskObject?> findTask(TaskObject task) {
    return _tasksRepository.findTask(task);
  }
  
  @override
  Future<void> updateTask(TaskObject task) {
    return _tasksRepository.updateTask(task);
  }
  
  @override
  Future<void> finishTask(TaskObject task) {
    return _tasksRepository.finishTask(task);
  }
  
  Future<List<TaskObject>> getOldTasks() async {
    try {
      // Chama o método do repositório
      final oldTasks = await _tasksRepository.getOldTasks();
      
      // Retorna a lista de tarefas antigas ou uma lista vazia em caso de erro
      return oldTasks ?? []; // Garante que não retornará nulo
    } catch (e) {
      // Trate qualquer exceção, se necessário
      print('Erro ao buscar tarefas antigas: $e');
      
      // Retorna uma lista vazia em caso de erro
      return [];
    }
  }
  
  

  
}
