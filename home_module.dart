import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/home/home_page.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';
import 'package:organizame/app/services/tasks/tasks_service_impl.dart';
import 'package:provider/provider.dart';

class HomeModule extends OrganizameModule {
  HomeModule()
      : super(
          bindings: [
            Provider<TasksRepository>(
              create: (context) => TasksRepositoryImpl(sqLiteConnectionFactory: context.read()),
            ),
            Provider<TasksService>(
              create: (context) => TasksServiceImpl(tasksRepository: context.read()),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeController(tasksService: context.read()),
            ),
          ],
          routers: {
            '/home': (context) => HomePage(homeController: context.read(),
              taskController: context.read(),
            ),
            
          },
        );
}
