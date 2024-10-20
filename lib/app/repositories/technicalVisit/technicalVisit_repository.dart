import 'package:organizame/app/models/technicalVisit_object.dart';

abstract class TechnicalVisitRepository {
  
  Future<void> createTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits();
}
