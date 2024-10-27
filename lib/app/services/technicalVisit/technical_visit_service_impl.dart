import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

import './technical_visit_service.dart';

class TechnicalVisitServiceImpl extends TechnicalVisitService {
  final TechnicalVisitRepository _technicalVisitRepository;

  TechnicalVisitServiceImpl({
    required TechnicalVisitRepository technicalVisitRepository,
  }) : _technicalVisitRepository = technicalVisitRepository;

  @override
  Future<void> saveTechnicalVisit(
          DateTime data, DateTime hora, CustomerObject cliente) =>
      _technicalVisitRepository.saveTechnicalVisit(data, hora, cliente);

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() =>
      _technicalVisitRepository.getAllTechnicalVisits();

  @override
  Future<bool> deleteTechnicalVisit(
          TechnicalVisitObject technicalVisitObject) =>
      _technicalVisitRepository.deleteTechnicalVisit(technicalVisitObject);

  @override
  Future<List<TechnicalVisitObject>> getTechnicalVisitsByCustomer(
          String customerName) =>
      _technicalVisitRepository.getTechnicalVisitsByCustomer(customerName);

  @override
  Future<List<TechnicalVisitObject>> getTechnicalVisitsByDate(DateTime date) =>
      _technicalVisitRepository.getTechnicalVisitsByDate(date);
}
