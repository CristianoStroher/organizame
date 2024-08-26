// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/task_filter_enum.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';

class HomeController extends DefautChangeNotifer {

  final TasksService _tasksService;

  HomeController({
    required  TasksService tasksService,
  }) : _tasksService = tasksService;

  var filterSelected = TaskFilterEnum.today;


  // HomeController() { iago colocou isso aqui
  //   hideLoading();
  // }
}
