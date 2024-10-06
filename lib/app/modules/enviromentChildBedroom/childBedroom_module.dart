
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/enviromentChildBedroom/childBedroom_page.dart';

class ChildBedroomModule extends OrganizameModule {
  ChildBedroomModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider(
          //   //   create: (context) => ChildBedroomController(),
          //   // ),
          // ],
          routers: {
            '/childBedroom': (context) => ChildBedroomPage(
                  // controller: context.read(),
                ),
          },
        );
  
}