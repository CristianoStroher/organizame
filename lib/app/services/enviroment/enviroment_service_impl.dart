import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';

import './enviroment_service.dart';

class EnviromentServiceImpl extends EnviromentService {
  
  final EnviromentRepository _repository;

  EnviromentServiceImpl({
    required EnviromentRepository repository,
  }) : _repository = repository;

  @override
  Future<void> addEnvironmentToVisit(String visitId, EnviromentObject environment) async {
    try {
      Logger().i('Service - Iniciando adição do ambiente');
      await _repository.addEnvironmentToVisit(visitId, environment);
      Logger().i('Service - Ambiente adicionado com sucesso');
    } catch (e) {
      Logger().e('Service - Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeEnvironmentFromVisit(String visitId, String environmentId) async {
    try {
      Logger().i('Service - Iniciando remoção do ambiente');
      await _repository.removeEnvironmentFromVisit(visitId, environmentId);
      Logger().i('Service - Ambiente removido com sucesso');
    } catch (e) {
      Logger().e('Service - Erro ao remover ambiente: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateEnvironmentInVisit(
      String visitId, EnviromentObject environment) async {
    try {
      Logger().i('Service - Iniciando atualização do ambiente');
      await _repository.updateEnvironmentInVisit(visitId, environment);
      Logger().i('Service - Ambiente atualizado com sucesso');
    } catch (e) {
      Logger().e('Service - Erro ao atualizar ambiente: $e');
      rethrow;
    }
  }

}