
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';

class EnviromentModule extends OrganizameModule {
  EnviromentModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider(create: (context) => EnviromentController()),            
          //             ],
          routers: {
            '/environment': (context) => const EnviromentPage(),
          }, 
        );


  
}