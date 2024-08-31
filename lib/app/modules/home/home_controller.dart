import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';

import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/models/task_total_filter.dart';
import 'package:organizame/app/models/task_week_object.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';

class HomeController extends DefautChangeNotifer {

  final TasksService _tasksService;

  TaskTotalFilter? todayTotalTasks;
  TaskTotalFilter? tomorrowTotalTasks;
  TaskTotalFilter? weekTotalTasks;
  List<TaskObject> alltasks = [];
  List<TaskObject> filteredTasks = [];

  HomeController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  var filterSelected = TaskFilterEnum.today;

  Future<void> loadAllTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);

    final todayTasks = (allTasks[0] as List<TaskObject>)
      ..sort((a, b) => _combineDateTime(a).compareTo(_combineDateTime(b)));
    final tomorrowTasks = (allTasks[1] as List<TaskObject>)
      ..sort((a, b) => _combineDateTime(a).compareTo(_combineDateTime(b)));
    final weekTasks = allTasks[2] as TaskWeekObject;

    weekTasks.tasks
        .sort((a, b) => _combineDateTime(a).compareTo(_combineDateTime(b)));

    todayTotalTasks = TaskTotalFilter(
      totalTasks: todayTasks.length,
      totalTasksFinished:
          todayTasks.where((element) => element.finalizado).length,
    );

    tomorrowTotalTasks = TaskTotalFilter(
      totalTasks: tomorrowTasks.length,
      totalTasksFinished:
          tomorrowTasks.where((element) => element.finalizado).length,
    );

    weekTotalTasks = TaskTotalFilter(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinished:
          weekTasks.tasks.where((element) => element.finalizado).length,
    );

    notifyListeners();
    
  }

  Future<void> findFilter({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskObject> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekObjet = await _tasksService.getWeek();
        tasks = weekObjet.tasks;
        // initialDateOfWeek = weekObjet.startDate;
        break;
    }

    // Ordena as tarefas por data e hora combinadas
    tasks.sort((a, b) => _combineDateTime(a).compareTo(_combineDateTime(b)));

    filteredTasks = tasks;
    alltasks = tasks;

    hideLoading();
    notifyListeners();
  }

  // Função auxiliar para combinar data e hora
  DateTime _combineDateTime(TaskObject task) {
    return DateTime(
      task.data.year,
      task.data.month,
      task.data.day,
      task.hora.hour,
      task.hora.minute,
    );
  }

  Future<void> refreshPage() async {
    await loadAllTasks();
    await findFilter(filter: filterSelected);
    notifyListeners();

  }

}
