import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:organizame/app/app_widget.dart';
import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
import 'package:organizame/app/modules/enviromentChildBedroom/childBedroom_controller.dart';
import 'package:organizame/app/modules/visit/environment/enviroment_controller.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
import 'package:organizame/app/modules/enviromentKitchen/kitchen_controller.dart';
import 'package:organizame/app/modules/enviromentLivingRoom/livingRoom_controller.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/modules/visit/visit_controller.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import 'package:organizame/app/repositories/user/user_repository_impl.dart';
import 'package:organizame/app/services/customer/customer_service.dart';
import 'package:organizame/app/services/customer/customer_service_impl.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';
import 'package:organizame/app/services/tasks/tasks_service_impl.dart';
import 'package:organizame/app/services/user_service.dart';
import 'package:organizame/app/services/user_service_impl.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_provider.dart';
import 'modules/visit/customer/customer_controller.dart';

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
        Provider(create: (_) => SqliteConnectionFactory(), lazy: false,), //injetando a instância do sqlite
        Provider<CustomerService>(create: (_) => CustomerServiceImpl(customerRepository: context.read())), //injetando o serviço de cliente
        Provider<UserRepository>(create: (context) => UserRepositoryImpl(firebaseAuth: context.read(),firestore: context.read())), //injetando o repositório do usuário //adicionado firestore
        Provider<UserService>(create: (context) => UserServiceImpl(userRepository: context.read(),loginValidators: context.read())), //injetando o serviço do usuário
        Provider<TasksRepository>(create: (context) => TasksRepositoryImpl(sqLiteConnectionFactory: context.read())), //injetando o repositório de tarefas
        Provider<TasksService>(create: (context) =>TasksServiceImpl(tasksRepository: context.read())), //injetando o serviço de tarefas
        ChangeNotifierProvider(create: (context) => AuthProvider(firebaseAuth: context.read(), userService: context.read(),)..loadListener(), lazy: false,), //injetando o provider de autenticação
        ChangeNotifierProvider<TaskController>(create: (context) => TaskController(tasksService: context.read(),),), //injetando o controller do módulo task
        ChangeNotifierProvider(create: (context) => HomeController(tasksService: context.read())), //injetando o controller do módulo home
        ChangeNotifierProvider(create: (context) => TecnicalController()), //injetando o controller do módulo tecnical
        ChangeNotifierProvider(create: (context) => VisitController()), //injetando o controller do módulo visit
        ChangeNotifierProvider(create: (context) => CustomerController(customerService: context.read())),//injetando o controller do módulo
        ChangeNotifierProvider(create: (context) => EnviromentController()), //injetando o controller do módulo enviroment
        ChangeNotifierProvider(create: (context) => LivingRoomController()), //injetando o controller do módulo livingRoom
        ChangeNotifierProvider(create: (context) => ChildBedroomController()), //injetando o controller do módulo childBedroom
        ChangeNotifierProvider(create: (context) => KitchenController()), //injetando o controller do módulo kitchen
        
      ],      child: const AppWidget(),
    );
  }
}
