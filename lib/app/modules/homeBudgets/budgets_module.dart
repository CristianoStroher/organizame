
import 'package:organizame/app/core/modules/organizame_module.dart';

class BudgetsModule extends OrganizameModule {
  BudgetsModule()
      : super(
          bindings: [
            
          ],
          routers: {
            '/budgets': (context) =>
               B(homeController: context.read(), taskController: context.read()),
          },
        );

}