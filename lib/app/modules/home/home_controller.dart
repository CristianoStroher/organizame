// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  

  HomeController({
    required  TasksService tasksService,
  }) : _tasksService = tasksService;

  var filterSelected = TaskFilterEnum.today;

  Future<void> loadAllTasks() async {
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);

    final todayTasks = allTasks[0] as List<TaskObject>;
    final tomorrowTasks = allTasks[1] as List<TaskObject>;
    final weekTasks = allTasks[2] as TaskWeekObject; 

    todayTotalTasks = TaskTotalFilter(
      totalTasks: todayTasks.length,
      totalTasksFinished: todayTasks.where((element) => element.finalizado).length,
    );

    tomorrowTotalTasks = TaskTotalFilter(
      totalTasks: tomorrowTasks.length,
      totalTasksFinished: tomorrowTasks.where((element) => element.finalizado).length,
    );

    weekTotalTasks = TaskTotalFilter(
      totalTasks: weekTasks.tasks.length,
      totalTasksFinished: weekTasks.tasks.where((element) => element.finalizado).length,
    );

    notifyListeners();

    //  

    }

    Future<void> findFilter({required TaskFilterEnum filter}) async {
      filterSelected = filter;
      notifyListeners();
    }

  }


