
import 'package:organizame/app/app_module.dart';
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:provider/provider.dart';

class ChildBedroomModule extends OrganizameModule {
  ChildBedroomModule()
      : super(
          bindings: [
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

            ChangeNotifierProvider<TechnicalVisitController>(
              create: (context) => TechnicalVisitController(
                service: context.read<TechnicalVisitService>(),
              ),
            ),
           
          ],
          
          routers: {
            '/childBedroom': (context) => ChildBedroomPage(controller: context.read<TechnicalVisitController>()),
                  
                
          },
        );
  
}