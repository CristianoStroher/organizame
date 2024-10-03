import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/visit/visit_controller.dart';
import 'package:organizame/app/modules/visit/visit_create_page.dart';
import 'package:provider/provider.dart';

class VisitModule extends OrganizameModule {
  VisitModule()
      : super(
          bindings: [
            ChangeNotifierProvider(
              create: (context) => VisitController(),
            ),
          ],
          routers: {
            '/visit/create': (context) => VisitCreatePage(
                  // controller: context.read(),
                ),
          },
        );
}
