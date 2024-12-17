import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_Bedroom_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository_impl.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/enviroment/enviroment_service.dart';
import 'package:organizame/app/services/enviroment/enviroment_service_impl.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service_impl.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:provider/provider.dart';

class ChildBedroomModule extends OrganizameModule {
  ChildBedroomModule()
      : super(
          bindings: [
            // Repositories
            Provider<TechnicalVisitRepository>(
              create: (context) => TechnicalVisitRepositoryImpl(
                firestore: context.read(),
              ),
            ),
            Provider<EnviromentImagesRepository>(
              create: (context) => EnviromentImagesRepositoryImpl(),
            ),

            // Services
            Provider<TechnicalVisitService>(
              create: (context) => TechnicalVisitServiceImpl(
                repository: context.read<TechnicalVisitRepository>(),
              ),
            ),
            Provider<EnviromentImagesService>(
              create: (context) => EnviromentImagesServiceImpl(
                repository: context.read<EnviromentImagesRepository>(),
              ),
            ),
            Provider<EnviromentService>(
              create: (context) => EnviromentServiceImpl(
                repository: context.read<EnviromentRepository>(),
              ),
            ),

            // Controllers
            ChangeNotifierProvider<TechnicalVisitController>(
              create: (context) => TechnicalVisitController(
                service: context.read<TechnicalVisitService>(),
                enviromentService: context.read<EnviromentService>(),
              ),
            ),
          ],
          routers: {
            '/childBedroom': (context) {
              // Garante que todos os providers necessários estejam disponíveis
              return MultiProvider(
                providers: [
                  Provider<EnviromentImagesService>(
                    create: (context) => EnviromentImagesServiceImpl(
                      repository: context.read<EnviromentImagesRepository>(),
                    ),
                  ),
                ],
                child: ChildBedroomPage(
                  controller: context.read<TechnicalVisitController>(),
                ),
              );
            },
          },
        );
}
