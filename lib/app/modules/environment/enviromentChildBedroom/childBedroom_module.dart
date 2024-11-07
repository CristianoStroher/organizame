
import 'package:organizame/app/app_module.dart';
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_page.dart';
import 'package:provider/provider.dart';

class ChildBedroomModule extends OrganizameModule {
  ChildBedroomModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider(
          //   //   create: (context) => ChildBedroomController(),
          //   // ),
          // ],
          routers: {
            '/childBedroom': (context) => ChildBedroomPage(technicalVisitController: context.read()),
                  // controller: context.read(),
                
          },
        );
  
}