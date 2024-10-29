import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:organizame/app/app_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizame/app/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Habilita o logging detalhado do Firestore apenas em modo de depuração
  if (kDebugMode) {
    FirebaseFirestore.setLoggingEnabled(true);
    // Opcional: Definir configurações de persistência
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  runApp(const AppModule());
}