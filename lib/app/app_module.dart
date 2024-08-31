import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:organizame/app/app_widget.dart';
import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/modules/task/task_controller.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository.dart';
import 'package:organizame/app/repositories/tasks/tasks_repository_impl.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import 'package:organizame/app/repositories/user/user_repository_impl.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';
import 'package:organizame/app/services/tasks/tasks_service_impl.dart';
import 'package:organizame/app/services/user_service.dart';
import 'package:organizame/app/services/user_service_impl.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_provider.dart';

//! fica estrutura base do projeto onde estarão as configurações geral do projeto
//! e tudo que for compartilhado entre os módulos

class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    //injetando objetos que serão compartilhados entre os módulos
    return MultiProvider(
      providers: [
        Provider<LoginValidators>(
            create: (_) => LoginValidators
                .instance), //injetando a instância da classe de validação de login
        Provider(
            create: (_) =>
                FirebaseAuth.instance), //injetando a instância do firebase)
        Provider(
            create: (_) => FirebaseFirestore
                .instance), //injetando a instância do firestore
        Provider(
          create: (_) =>
              SqliteConnectionFactory(), //injetando a conexão com o banco de dados
          lazy: false, //sempre que for chamado ele vai criar uma nova instância
        ),
        Provider<UserRepository>(
            create: (context) => UserRepositoryImpl(
                firebaseAuth: context.read(),
                firestore: context
                    .read())), //injetando o repositório do usuário //adicionado firestore
        Provider<UserService>(
            create: (context) => UserServiceImpl(
                userRepository: context.read(),
                loginValidators: context.read())),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            firebaseAuth: context.read(),
            userService: context.read(),
          )..loadListener(),
          lazy: false, //logo que inicializado ja chama a função
        ),
        Provider<TasksRepository>(
            create: (context) =>
                TasksRepositoryImpl(sqLiteConnectionFactory: context.read())),
        Provider<TasksService>(
            create: (context) =>
                TasksServiceImpl(tasksRepository: context.read())),
        ChangeNotifierProvider<TaskController>(
          create: (context) => TaskController(
            tasksService: context.read(),           
          ),
        ),

        ChangeNotifierProvider(
            create: (context) => HomeController(tasksService: context.read())),
      ],
      child: const AppWidget(),
    );
  }
}
