import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/task/task_create_page.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:organizame/app/services/Tasks/tasks_service.dart';
import 'package:organizame/app/services/Tasks/tasks_service_impl.dart';
import 'package:provider/provider.dart';

class TaskModule extends OrganizameModule {
  TaskModule()
      : super(bindings: [
          Provider<TasksRepository>(
              create: (context) =>
                  TasksRepositoryImpl(sqLiteConnectionFactory: context.read())),
          Provider<TasksService>(
              create: (context) =>
                  TasksServiceImpl(tasksRepository: context.read())),
          ChangeNotifierProvider(
            create: (context) => TaskController(tasksService: context.read()),
          ),
        ], router: {
          '/task/create': (context) => TaskCreatePage(
                controller: context.read(),
              ),
        });
}
