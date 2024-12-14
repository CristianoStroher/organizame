
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_page.dart';
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_page.dart';
import 'package:organizame/app/modules/environment/enviromentLivingRoom/living_room_page.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/enviroment/enviroment_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:provider/provider.dart';

class EnviromentModule extends OrganizameModule {

  EnviromentModule()
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
                enviromentService: context.read<EnviromentService>(),
              ),
            ),
           
          ],        
          
          routers: {
            '/environment': (context) => EnviromentPage(technicalVisitController: context.read<TechnicalVisitController>(),),
            '/childBedroom': (context) => ChildBedroomPage(controller: context.read<TechnicalVisitController>()),
            '/kitchen': (context) => KitchenPage(controller: context.read<TechnicalVisitController>()),
            '/livingRoom': (context) => LivingRoomPage(controller: context.read<TechnicalVisitController>()),        

            
          },
        );  
  
  
}