
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_page.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository_impl.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';
import 'package:organizame/app/repositories/customer/customer_repository_impl.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';
import 'package:organizame/app/services/budgets/budgets_service_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:provider/provider.dart';

class BudgetsModule extends OrganizameModule {

  BudgetsModule()
      : super(
          bindings: [

            Provider<BudgetsRepository>(
              create: (context) => BudgetsRepositoryImpl(firestore: context.read()),),  
              
            Provider<CustomerRepository>(
              create: (context) => CustomerRepositoryImpl(firestore: context.read()),),
            
            Provider<BudgetsService>(
              create: (context) => BudgetsServiceImpl(budgetsRepository: context.read()),),

            Provider<CustomerService>(create: (context) => CustomerServiceImpl(customerRepository: context.read()),),
            
            ChangeNotifierProvider<CustomerController>(
              create: (context) => CustomerController(
                customerService: context.read<CustomerService>(),
              ),
            ),

            ChangeNotifierProvider<BudgetsController>(
              create: (context) => BudgetsController(service: context.read<BudgetsService>(), customerController: context.read<CustomerController>(),), ),
            
            ChangeNotifierProvider<BudgetsCreateController>(
              create: (context) => BudgetsCreateController(service: context.read<BudgetsService>(),),)
            
          ],
          routers: {
            '/budgets': (context) => BudgetsPage(controller: context.read(),),
            '/budgets/create': (context) => BudgetsCreatePage(controller: context.read(), createController: context.read(),),
          },
        );

}