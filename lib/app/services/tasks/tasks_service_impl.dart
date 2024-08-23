import 'package:organizame/app/repositories/tasks/tasks_repository.dart';

import './tasks_service.dart';

class TasksServiceImpl extends TasksService {
  
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository tasksRepository})
      : _tasksRepository = tasksRepository;

  @override
  Future<void> saveTask(DateTime date, DateTime time, String description,
      {String? observations}) => _tasksRepository.saveTask(date, time, description, observations: observations); 

}

