
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_page.dart';
import 'package:provider/provider.dart';

class BudgetsCreateModule extends OrganizameModule {
  BudgetsCreateModule()
      : super(
          // bindings: [
          //   // ChangeNotifierProvider<BudgetsCreateController>(
          //   //   create: (context) => BudgetsCreateController(),
          //   // ),
          // ],
          routers: {
            '/budgets/create': (context) => BudgetsCreatePage(controller: context.read(),),
          },
        );
  
}