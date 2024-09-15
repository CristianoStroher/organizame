
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/tecnical/tecnical_page.dart';
import 'package:provider/provider.dart';

class TecnicalModule extends OrganizameModule {

  TecnicalModule()
      : super(
          // bindings: [
          //   // Provider<TasksRepository>(
          //   //   create: (context) => TasksRepositoryImpl(sqLiteConnectionFactory: context.read()),
          //   // ),
          //   // Provider<TasksService>(
          //   //   create: (context) => TasksServiceImpl(tasksRepository: context.read()),
          //   // ),
          //   // ChangeNotifierProvider(
          //   //   create: (context) => HomeController(tasksService: context.read()),
          //   // ),
          // ],
          routers: {
            '/tecnical': (context) => TecnicalPage(),
          },
        );  
  
  
}