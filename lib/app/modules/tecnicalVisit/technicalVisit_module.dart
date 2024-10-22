import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_create_page.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';
import 'package:organizame/app/repositories/customer/customer_repository_impl.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:provider/provider.dart';

class TechnicalvisitModule extends OrganizameModule {
  TechnicalvisitModule()
      : super(
          bindings: [
            // Repositories
            Provider<CustomerRepository>(
              create: (context) => CustomerRepositoryImpl(
                firestore: context.read(),
              ),
            ),
            Provider<TechnicalVisitRepository>(
              create: (context) => TechnicalVisitRepositoryImpl(
                firestore: context.read(),
              ),
            ),

            // Services
            Provider<CustomerService>(
              create: (context) => CustomerServiceImpl(
                customerRepository: context.read(),
              ),
            ),
            Provider<TechnicalVisitService>(
              create: (context) => TechnicalVisitServiceImpl(
                technicalVisitRepository: context.read(),
              ),
            ),

            // Controllers
            ChangeNotifierProvider(
              create: (context) => TechnicalVisitController(
                technicalVisitService: context.read(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => CustomerController(
                customerService: context.read(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => EnviromentController(),
            ),
          ],
          routers: {
            '/visit/create': (context) => TechnicalvisitCreatePage(),
            '/customer/create': (context) => CustomerCreatePage(),
            '/environment': (context) => EnviromentPage(),
          },
        );
}