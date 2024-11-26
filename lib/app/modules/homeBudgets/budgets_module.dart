
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_page.dart';
import 'package:provider/provider.dart';

class BudgetsModule extends OrganizameModule {

  BudgetsModule()
      : super(
          bindings: [

            

             ChangeNotifierProvider<BudgetsController>(
              create: (context) => BudgetsController(),
            ),
            
          ],
          routers: {
            '/budgets': (context) => BudgetsPage(controller: context.read()),
            '/budgets/create': (context) => BudgetsPage(controller: context.read()),
          },
        );

}