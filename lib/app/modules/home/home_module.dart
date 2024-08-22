import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/home/home_page.dart';

class HomeModule extends OrganizameModule {
  HomeModule()
      : super(
          /* bindings: [], */
          routers: {
            '/home': (context) => const HomePage(),
            
          },
        );
}
