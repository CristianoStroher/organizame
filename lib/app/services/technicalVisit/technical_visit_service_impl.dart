import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

import './technical_visit_service.dart';

class TechnicalVisitServiceImpl extends TechnicalVisitService {
  
  final TechnicalVisitRepository _technicalVisitRepository;

  TechnicalVisitServiceImpl({
    required TechnicalVisitRepository technicalVisitRepository,
  }) : _technicalVisitRepository = technicalVisitRepository;

  @override
  Future<void> saveTechnicalVisit(TechnicalVisitObject technicalVisitObject) async {

    if (!technicalVisitObject.isValid()) {
      throw ArgumentError('Visita técnica inválida');
    }
    await _technicalVisitRepository.saveTechnicalVisit(technicalVisitObject);

}

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() {

        return _technicalVisitRepository.getAllTechnicalVisits();
  }
}