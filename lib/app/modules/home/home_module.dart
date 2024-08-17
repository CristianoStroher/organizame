import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/home/home_page.dart';

class HomeModule extends OrganizameModule {
  HomeModule()
      : super(
          /* bindings: [], */
          router: {
            '/home': (context) => const HomePage(),
          },
        );
}
