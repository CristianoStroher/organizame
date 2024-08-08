import 'package:flutter/material.dart';
import 'package:organizame/app/core/database/sqlite_connection_factory.dart';

/* Essa classe é responsável por controlar a conexão com o banco de dados em todo app observando
e verificar quando ele está ativo ou não

*/
class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final connection = SqliteConnectionFactory();

    switch (state) {
      case AppLifecycleState.resumed:
        connection.openConnection();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      default:
        connection.closeConnection();
        break;
      
    }

    super.didChangeAppLifecycleState(state);
  }
}
