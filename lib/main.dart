import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/app_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizame/app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

final FirebaseFirestore firestore = FirebaseFirestore.instance;

  runApp(const AppModule());
}


