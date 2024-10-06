import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/enviromentKitchen/kitchen_page.dart';

class KitchenModule extends OrganizameModule {
  KitchenModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider(
          //   //   create: (context) => KitchenController(),
          //   // ),
          // ],
          routers: {
            '/kitchen': (context) => KitchenPage(
                  // controller: context.read(),
                ),
          },
        );
  
}