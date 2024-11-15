import 'dart:io';

import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_imagens.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

abstract class TechnicalVisitService {

  Future<void> saveTechnicalVisit(DateTime data, DateTime hora, CustomerObject cliente);
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits();
  Future<bool> deleteTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<TechnicalVisitObject> findTechnicalVisitById(String id);
  Future<void> addEnvironmentToVisit(String visitId, EnviromentObject environment);
  Future<void> removeEnvironmentFromVisit(String visitId, String environmentId);
  Future<void> updateEnvironmentInVisit(String visitId, EnviromentObject environment);
  


}