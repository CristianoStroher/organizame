import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_create_page.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';
import 'package:organizame/app/repositories/customer/customer_repository_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:provider/provider.dart';

class TechnicalvisitModule extends OrganizameModule {
  TechnicalvisitModule()
      : super(
          bindings: [
            Provider<CustomerRepository>(
                create: (context) => CustomerRepositoryImpl(
                    firestore:
                        context.read())), //injetando o repositório de cliente
            Provider<CustomerService>(
                create: (context) => CustomerServiceImpl(
                    customerRepository:
                        context.read())), // injetando o serviço de cliente
            ChangeNotifierProvider(
                create: (context) =>
                    TechnicalVisitController(technicalVisitService: context.read())), // injetando o controller da tela de visitas
            ChangeNotifierProvider(
                create: (context) => CustomerController(customerService: context.read())), // injetando o controller da tela de clientes
            ChangeNotifierProvider(
                create: (context) =>
                    EnviromentController()), // injetando o controller da tela de ambiente
          ],
          routers: {
            '/visit/create': (context) =>
                TechnicalvisitCreatePage(), // rota para a tela de criação de visitas
            '/customer/create': (context) => CustomerCreatePage(), // rota para a tela de criação de clientes
            '/environment': (context) =>
                const EnviromentPage(), // rota para a tela de ambiente
          },
        );
}

