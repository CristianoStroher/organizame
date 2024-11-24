
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_page.dart';
import 'package:provider/provider.dart';

class BudgetsModule extends OrganizameModule {
  
  BudgetsModule()
      : super(
          bindings: [
            
          ],
          routers: {
            '/budgets': (context) =>
               BudgetsPage(controller: context.read()),
          },
        );

}