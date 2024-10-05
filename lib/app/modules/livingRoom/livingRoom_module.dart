import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/livingRoom/livingRoom_page.dart';

class LivingRoomModule extends OrganizameModule {
  LivingRoomModule()
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
            '/livingRoom': (context) => LivingRoomPage(),
          },
        );

 

  
}