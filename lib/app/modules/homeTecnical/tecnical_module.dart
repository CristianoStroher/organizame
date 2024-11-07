
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_page.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:provider/provider.dart';

class TecnicalModule extends OrganizameModule {

  TecnicalModule()
      : super(
          bindings: [
            // Repository
            Provider<TechnicalVisitRepository>(
              create: (context) => TechnicalVisitRepositoryImpl(
                firestore: context.read(),
              ),
            ),
            
            // Service
            Provider<TechnicalVisitService>(
              create: (context) => TechnicalVisitServiceImpl(
                repository: context.read<TechnicalVisitRepository>(),
              ),
            ),
            
            // Controller
            ChangeNotifierProvider<TechnicalController>(
              create: (context) => TechnicalController(
                technicalVisitService: context.read<TechnicalVisitService>(),
              ),
            ),
          ],
          routers: {
            '/tecnical': (context) => const TecnicalPage(),
            '/tecnical/customer/create': (context) => const CustomerCreatePage(),             

            
          },
        );  
  
  
}