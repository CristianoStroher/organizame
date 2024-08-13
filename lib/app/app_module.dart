import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/app_widget.dart';
import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import 'package:organizame/app/repositories/user/user_repository_impl.dart';
import 'package:organizame/app/services/user_service.dart';
import 'package:organizame/app/services/user_service_impl.dart';
import 'package:provider/provider.dart';

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
        Provider(create: (_) => FirebaseAuth.instance), //injetando a instância do firebase)
        Provider(create: (_) => FirebaseFirestore.instance), //injetando a instância do firestore
        Provider(create: (_) => SqliteConnectionFactory(), //injetando a conexão com o banco de dados
          lazy: false,
        ),
        Provider<UserRepository>(create: (context) => UserRepositoryImpl(firebaseAuth: context.read(), firestore: context.read())), //injetando o repositório do usuário //adicionado firestore
        Provider<UserService>(create: (context) => UserServiceImpl(userRepository: context.read(), loginValidators: context.read())), //injetando o serviço do usuário
      ],
      child: const AppWidget(),
    );
  }
}
