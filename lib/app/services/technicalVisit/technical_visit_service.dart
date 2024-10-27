import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

abstract class TechnicalVisitService {

  Future<void> saveTechnicalVisit(DateTime data, DateTime hora, CustomerObject cliente);
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits();
  Future<bool> deleteTechnicalVisit(TechnicalVisitObject technicalVisit);
  Future<List<TechnicalVisitObject>> getTechnicalVisitsByCustomer(String customerName);
  Future<List<TechnicalVisitObject>> getTechnicalVisitsByDate(DateTime date);

}