import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

import './technical_visit_service.dart';

class TechnicalVisitServiceImpl extends TechnicalVisitService {
  
  final TechnicalVisitRepository _technicalVisitRepository;

  TechnicalVisitServiceImpl({
    required TechnicalVisitRepository technicalVisitRepository,
  }) : _technicalVisitRepository = technicalVisitRepository;

  @override
  Future<void> createTechnicalVisit(TechnicalVisitObject technicalVisit) async {

    if (!technicalVisit.isValid()) {
      throw ArgumentError('Visita técnica inválida');
    }
    await _technicalVisitRepository.createTechnicalVisit(technicalVisit);

}
}