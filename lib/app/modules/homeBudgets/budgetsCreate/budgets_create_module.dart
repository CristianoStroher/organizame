import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_page.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository_impl.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';
import 'package:organizame/app/services/budgets/budgets_service_impl.dart';
import 'package:provider/provider.dart';

class BudgetsCreateModule extends OrganizameModule {
  BudgetsCreateModule()
      : super(
          bindings: [

            Provider<BudgetsRepository>(create: (context) => BudgetsRepositoryImpl(firestore: context.read()),),

            // Service
            Provider<BudgetsService>(create: (context) => BudgetsServiceImpl(budgetsRepository: context.read()),),

            ChangeNotifierProvider<BudgetsCreateController>(
              create: (context) => BudgetsCreateController(
                  service: context.read<BudgetsServiceImpl>()),
            ),
          ],
          routers: {
            '/budgets/create': (context) => BudgetsCreatePage(controller: context.read(),),
          },
        );
}
