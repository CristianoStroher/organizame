import 'dart:io';

import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

abstract class TechnicalVisitRepository {
  
  Future<void> saveTechnicalVisit(DateTime data,DateTime hora, CustomerObject cliente);
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits();
  Future<bool> deleteTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<TechnicalVisitObject> findTechnicalVisitById(String id);

}
