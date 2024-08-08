import 'package:flutter/material.dart';
import 'package:organizame/app/app_widget.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
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
        Provider(
          create: (_) => SqliteConnectionFactory(), //injetando a conexão com o banco de dados
          lazy: false,
        )
      ],
      child: AppWidget(),
    );
  }
}
