import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

import './technical_visit_service.dart';

class TechnicalVisitServiceImpl extends TechnicalVisitService {
  
  final TechnicalVisitRepository _repository;

  TechnicalVisitServiceImpl({
    required TechnicalVisitRepository repository,
  }) : _repository = repository;

  @override
  Future<void> saveTechnicalVisit(
          DateTime data, DateTime hora, CustomerObject cliente) =>
      _repository.saveTechnicalVisit(data, hora, cliente);

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() =>
      _repository.getAllTechnicalVisits();

  @override
  Future<bool> deleteTechnicalVisit(
          TechnicalVisitObject technicalVisitObject) =>
      _repository.deleteTechnicalVisit(technicalVisitObject);

  @override
  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      // Validação de ID
      if (technicalVisit.id == null) {
        Logger().e('Não é possível atualizar uma visita sem ID');
        throw Exception('Não é possível atualizar uma visita sem ID');
      }

      // Atualiza a visita
      await _repository.updateTechnicalVisit(technicalVisit);
      Logger().i('Visita atualizada com sucesso: ${technicalVisit.id}');
    } catch (e) {
      Logger().e('Erro ao atualizar visita técnica: $e');
      rethrow;
    }
  }

  @override
  Future<TechnicalVisitObject> findTechnicalVisitById(String id) =>
      _repository.findTechnicalVisitById(id);



}

      
 


