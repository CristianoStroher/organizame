import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/core/database/sqlite_adm_connection.dart';
import 'package:organizame/app/core/navigator/organizame_navigator.dart';
import 'package:organizame/app/core/ui/desing_ui.dart';
import 'package:organizame/app/modules/auth/auth_module.dart';

import 'package:organizame/app/modules/home/home_module.dart';
import 'package:organizame/app/modules/splash/splash_page.dart';

//! praticamente a implementação do material app que tem a função de ser
//! o widget raiz da aplicação 

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  final sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance?.addObserver(sqliteAdmConnection);   
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(sqliteAdmConnection);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizame',
      theme: DesingUi.theme,
      navigatorKey: OrganizameNavigator.navigatorKey,
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
      },
      home: const SplashPage(),
    );
  }
}
