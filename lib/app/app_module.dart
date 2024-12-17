import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/app_widget.dart';
import 'package:organizame/app/core/validators/login_validators.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/child_bedroom_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgetsCreate/budgets_create_controller.dart';
import 'package:organizame/app/modules/homeBudgets/budgets_controller.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_controller.dart';
import 'package:organizame/app/modules/environment/enviromentLivingRoom/living_room_controller.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository_impl.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository_impl.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository_impl.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:organizame/app/repositories/technicalVisit/technical_visit_repository_impl.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import 'package:organizame/app/repositories/user/user_repository_impl.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';
import 'package:organizame/app/services/budgets/budgets_service_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/enviroment/enviroment_service.dart';
import 'package:organizame/app/services/enviroment/enviroment_service_impl.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service_impl.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';
import 'package:organizame/app/services/tasks/tasks_service_impl.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service_impl.dart';
import 'package:organizame/app/services/user/user_service.dart';
import 'package:organizame/app/services/user/user_service_impl.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_provider.dart';
import 'modules/tecnicalVisit/customer/customer_controller.dart';

//! fica estrutura base do projeto onde estarão as configurações geral do projeto
//! e tudo que for compartilhado entre os módulos

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    //injetando objetos que serão compartilhados entre os módulos
    return MultiProvider(
      providers: [

        Provider<LoginValidators>(create: (_) => LoginValidators.instance), //injetando a instância da classe de validação de login
        Provider(create: (_) =>FirebaseAuth.instance), //injetando a instância do firebase)
        Provider(create: (_) => FirebaseFirestore.instance), //injetando a instância do firestore
        Provider(create: (_) => FirebaseStorage.instance), //injetando a instância do firestore
        Provider(create: (_) => SqliteConnectionFactory(), lazy: false,), //injetando a instância do sqlite
    
        Provider<UserRepository>(create: (context) => UserRepositoryImpl(firebaseAuth: context.read(),firestore: context.read())), //injetando o repositório do usuário //adicionado firestore
        Provider<TechnicalVisitRepository>(create: (context) => TechnicalVisitRepositoryImpl(firestore: context.read<FirebaseFirestore>())), //injetando o controller do módulo technicalVisit
        Provider<EnviromentImagesRepository>(create: (context) => EnviromentImagesRepositoryImpl()), //injetando o repositório de imagens
        Provider<TasksRepository>(create: (context) => TasksRepositoryImpl(sqLiteConnectionFactory: context.read())), //injetando o repositório de tarefas
        Provider<EnviromentRepository>(create: (context) => EnviromentRepositoryImpl(firestore: context.read()),), //injetando o repositório de ambiente
        Provider<BudgetsRepository>(create: (context) => BudgetsRepositoryImpl(firestore: context.read()),), //injetando o repositório de orçamentos
        
        Provider<UserService>(create: (context) => UserServiceImpl(userRepository: context.read(),loginValidators: context.read())), //injetando o serviço do usuário
        Provider<TasksService>(create: (context) =>TasksServiceImpl(tasksRepository: context.read())), //injetando o serviço de tarefas
        Provider<TechnicalVisitService>(create: (context) => TechnicalVisitServiceImpl(repository: context.read<TechnicalVisitRepository>(),),),
        Provider<EnviromentService>(create: (context) => EnviromentServiceImpl(repository: context.read<EnviromentRepository>()),), //injetando o serviço de ambiente
        Provider<BudgetsService>(create: (context) => BudgetsServiceImpl(budgetsRepository: context.read()),), //injetando o serviço de orçamentos
        Provider<EnviromentImagesService>(create: (context) => EnviromentImagesServiceImpl(repository: context.read()),), //injetando o serviço de imagens

        ChangeNotifierProvider(create: (context) => AuthProvider(firebaseAuth: context.read(), userService: context.read(),)..loadListener(), lazy: false,),//injetando o provider de autenticação
        ChangeNotifierProvider<TaskController>(create: (context) => TaskController(tasksService: context.read(),),), //injetando o controller do módulo task
        ChangeNotifierProvider(create: (context) => HomeController(tasksService: context.read())), //injetando o controller do módulo home
        ChangeNotifierProvider(create: (context) => TechnicalController(technicalVisitService: context.read())), //injetando o controller do módulo tecnical
        ChangeNotifierProvider(create: (context) => LivingRoomController(controller: context.read())), //injetando o controller do módulo livingRoom
        ChangeNotifierProvider(create: (context) => ChildBedroomController(controller:context.read(),imagenService: context.read())), //injetando o controller do módulo childBedroom
        ChangeNotifierProvider(create: (context) => KitchenController(controller: context.read(), imagenService: context.read())), //injetando o controller do módulo kitchen
        ChangeNotifierProvider(create: (context) => CustomerController(customerService: context.read<CustomerService>(),)), //injetando o controller do módulo customer
        ChangeNotifierProvider(create: (context) => TechnicalVisitController(service: context.read<TechnicalVisitService>(), enviromentService: context.read<EnviromentService>(),)), //injetando o controller do módulo technicalVisit
        ChangeNotifierProvider(create: (context) => BudgetsController(service: context.read<BudgetsService>(), customerController: context.read<CustomerController>()),), //injetando o controller do módulo budgets
        ChangeNotifierProvider(create: (context) => BudgetsCreateController(service: context.read<BudgetsService>(),)), //injetando o controller do módulo budgetsCreate

      ],      child: const AppWidget(),
    );
  }
}
