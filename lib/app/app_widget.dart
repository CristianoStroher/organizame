import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:organizame/app/core/database/sqlite_adm_connection.dart';
import 'package:organizame/app/core/navigator/organizame_navigator.dart';
import 'package:organizame/app/core/ui/desing_ui.dart';
import 'package:organizame/app/modules/auth/auth_module.dart';
import 'package:organizame/app/modules/environment/enviromentChildBedroom/childBedroom_module.dart';

import 'package:organizame/app/modules/homeTasks/home_module.dart';
import 'package:organizame/app/modules/environment/enviromentKitchen/kitchen_module.dart';
import 'package:organizame/app/modules/environment/enviromentLivingRoom/livingRoom_module.dart';
import 'package:organizame/app/modules/splash/splash_page.dart';
import 'package:organizame/app/modules/task/task_module.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_module.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_module.dart';



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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        ...TaskModule(context).routers,
        ...TecnicalModule().routers,
        ...TechnicalvisitModule().routers,
        ...KitchenModule().routers,
        ...LivingRoomModule().routers,
        ...ChildBedroomModule().routers,
      },
      home: const SplashPage(),
    );
  }
}
