import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/core/ui/messages.dart';
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
  DateTime? initialDateOfWeek;
  DateTime? selectedDate;
  bool showFinishingTasks = false;

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

    // Logger().i('allTasks: $allTasks');

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

    try {
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
          initialDateOfWeek = weekObjet.startDate;
          break;
      }
    } on Exception catch (e) {
      // Logger().e('Erro ao buscar tarefas: $e');
      return;
    }

    // Ordena as tarefas por data e hora combinadas
    tasks.sort((a, b) => _combineDateTime(a).compareTo(_combineDateTime(b)));

    filteredTasks = tasks;
    alltasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDate != null) {
        filterByDate(selectedDate!);
      } else if (initialDateOfWeek != null) {
        filterByDate(initialDateOfWeek!);
      }
    } else {
      selectedDate = null;
    }

    if (!showFinishingTasks) {
      filteredTasks = filteredTasks.where((task) => !task.finalizado).toList();
    }

    // Logger().i('Total de tarefas filtradas: ${filteredTasks.length}');
    // Logger().i('Mostrar tarefas finalizadas: $showFinishingTasks');

    hideLoading();
    notifyListeners();
  }

  void filterByDate(DateTime date) {
    selectedDate = date;
    filteredTasks = alltasks
        .where((task) =>
            task.data.year == date.year &&
            task.data.month == date.month &&
            task.data.day == date.day)
        .toList();
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

 
  Future<void> finishTask(TaskObject task) async {
    // Logger().i('Atualizando tarefa: $task');
    try {
      showLoadingAndResetState();
      final taskUpdate = task.copyWith(finalizado: !task.finalizado);
      await _tasksService.finishTask(taskUpdate);
      // Logger().e('Tarefa atualizada com sucesso');
      await refreshPage();
      hideLoading();
    } on Exception catch (e) {
      // Logger().e('Erro ao atualizar tarefa: $e');
      setError('Erro ao atualizar tarefa');
    }
  }

  Future<void> showOrHideFinishingTasks() async {
    showFinishingTasks = !showFinishingTasks;
    await refreshPage();
  }

  Future<bool> deleteTask(TaskObject task) async {
    try {
      showLoadingAndResetState();
      final result = await _tasksService.deleteTask(task);
      if (result) {
        success();
      } else {
        setError('Erro ao deletar tarefa');
      }
      return result; // Retorna o próprio resultado
    } catch (e, s) {
      setError('Erro ao deletar tarefa');
      return false;
    } finally {
      hideLoading();
      notifyListeners();
      refreshPage(); // Chama notifyListeners apenas uma vez no finally
    }
  }
  
}
