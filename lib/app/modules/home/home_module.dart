import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/home/home_page.dart';
import 'package:provider/provider.dart';

class HomeModule extends OrganizameModule {
  HomeModule()
      : super(
          bindings: [
            ChangeNotifierProvider(
              create: (context) => HomeController(tasksService: context.read()),
            ),
          ],
          routers: {
            '/home': (context) => const HomePage(),
            
          },
        );
}
