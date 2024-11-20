import 'package:flutter/material.dart';
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_create_page.dart';
import 'package:organizame/app/modules/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_create_page.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';
import 'package:organizame/app/repositories/customer/customer_repository_impl.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository_impl.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:organizame/app/services/enviroment/enviroment_service.dart';
import 'package:organizame/app/services/enviroment/enviroment_service_impl.dart';
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

            // Services
            Provider<CustomerService>(
              create: (context) => CustomerServiceImpl(
                customerRepository: context.read(),
              ),
            ),

            Provider<TechnicalVisitRepository>(
              create: (context) => TechnicalVisitRepositoryImpl(
                firestore: context.read(),
              ),
            ),

            Provider<TechnicalVisitService>(
              create: (context) => TechnicalVisitServiceImpl(
                repository: context.read(),
              ),
            ),

            Provider<EnviromentRepository>(
              create: (context) => EnviromentRepositoryImpl(
                firestore: context.read(),                
              ),
            ),

            // Services
            Provider<EnviromentService>(
              create: (context) => EnviromentServiceImpl(
                repository: context.read(),
              ),
            ),

            // Controllers
            ChangeNotifierProvider(
              create: (context) => TechnicalVisitController(
                service: context.read(), enviromentService: context.read(),
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
            '/customer/create': (context) => CustomerCreatePage(),
            '/environment': (context) => EnviromentPage(technicalVisitController: context.read(),),
            '/visit/create': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
              return TechnicalvisitCreatePage(
                technicalVisit: args?['visit'] as TechnicalVisitObject?,
                controller: context.read<TechnicalVisitController>(),
              );
            },
          },
        );
}
