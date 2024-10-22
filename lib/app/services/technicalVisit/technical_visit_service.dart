import 'package:organizame/app/models/technicalVisit_object.dart';

abstract class TechnicalVisitService {

  Future<void> saveTechnicalVisit(TechnicalVisitObject technicalVisitObject);
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits();

}