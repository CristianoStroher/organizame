import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/visit/customer/customer_controller.dart';
import 'package:organizame/app/modules/visit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/visit/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/visit/environment/enviroment_page.dart';
import 'package:organizame/app/modules/visit/visit_controller.dart';
import 'package:organizame/app/modules/visit/visit_create_page.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';
import 'package:organizame/app/repositories/customer/customer_repository_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:provider/provider.dart';

class VisitModule extends OrganizameModule {
  VisitModule()
      : super(
          // bindings: [
          //  Provider<CustomerRepository>(create: (context) => CustomerRepositoryImpl(firestore: context.read())), //injetando o repositório de cliente
          //   Provider<CustomerService>(create: (context) => CustomerServiceImpl(customerRepository: context.read())), // injetando o serviço de cliente
          //   ChangeNotifierProvider(create: (context) => VisitController()), // injetando o controller da tela de visitas
          //   ChangeNotifierProvider(create: (context) => CustomerController(customerService: context.read())), // injetando o controller da tela de clientes
          //   ChangeNotifierProvider(create: (context) => EnviromentController()), // injetando o controller da tela de ambiente
          
          // ],
          routers: {
            '/visit/create': (context) => VisitCreatePage(), // rota para a tela de criação de visitas
            '/customer/create': (context) => CustomerCreatePage(controller: context.read()), // rota para a tela de criação de clientes
            '/environment': (context) => const EnviromentPage(), // rota para a tela de ambiente
          },
        );
}
