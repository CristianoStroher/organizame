import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';

import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

class TechnicalVisitManager {
  TechnicalVisitObject _technicalVisit;
  final List<EnviromentObject> _environments = [];
  final Logger _logger = Logger();

  TechnicalVisitManager({
    required DateTime date,
    required DateTime time,
    required CustomerObject customer,
  }) : _technicalVisit = TechnicalVisitObject(
          date: date,
          time: time,
          customer: customer,
        );

  //getters
  TechnicalVisitObject get technicalVisit => _technicalVisit;
  List<EnviromentObject> get environments => List.unmodifiable(_environments);


  // Atualiza dados basicos da visita tecnica
  void updateTechnicalVisit({
    DateTime? date,
    DateTime? time,
    CustomerObject? customer,
  }) {
    _technicalVisit = _technicalVisit.copyWith(
      date: date ?? _technicalVisit.date,
      time: time ?? _technicalVisit.time,
      customer: customer ?? _technicalVisit.customer,
    );
  }

  // Adiciona um ambiente a visita tecnica
  void addEnvironment({
    required String id,
    required String name,
    required String description,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    try {
      final environment = EnviromentObject(
        id: id,
        name: name,
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: itens,
      );

      if (!environment.isValid()) {
        _logger.e('Ambiente inválido: $environment');
        throw Exception(
            'Ambiente inválido: $environment - campos obrigatórios não preenchidos');
      }

      _environments.add(environment);
    } catch (e) {
      _logger.e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  // Remove um ambiente
void removeEnviroment(String enviromentId) {
  try {
    final ambiente = _environments.firstWhere(
      (env) => env.id == enviromentId,
      orElse: () => throw Exception('Ambiente não encontrado: $enviromentId'),
    );
    
    _environments.remove(ambiente);
    _logger.i('Ambiente removido: $enviromentId');
  } catch (e) {
    _logger.e('Erro ao remover ambiente: $e');
    rethrow;
  }
}

  // Atualiza um ambiente da visita tecnica
  void updateEnvironment({
    required String id,
    String? name,
    String? description,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    try {
      final environmentIndex =
          _environments.indexWhere((element) => element.id == id);
      if (environmentIndex == -1) {
        _logger.w('Ambiente não encontrado');
        throw Exception('Ambiente não encontrado');
      }

      final enviromentNow = _environments[environmentIndex];
      final upadateEnvironment = enviromentNow.copyWith(
        name: name,
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: itens,
      );

      if (!upadateEnvironment.isValid()) {
        _logger.e('Ambiente inválido: $upadateEnvironment');
        throw Exception(
            'Ambiente inválido: $upadateEnvironment - campos obrigatórios não preenchidos');
      }

      _environments[environmentIndex] = upadateEnvironment;
    } catch (e) {
      _logger.e('Erro ao atualizar ambiente: $e');
      rethrow;
    }
  }

  // Atualiza um item específico de um ambiente
  void updateEnviromentItem(
      String enviromentId, EnviromentItensEnum item, bool value) {
    try {
      final ambiente =
          _environments.firstWhere((env) => env.id == enviromentId);
      ambiente.setItem(item, value);
      _logger.i(
          'Item ${item.name} atualizado para $value no ambiente ${ambiente.name}');
    } catch (e) {
      _logger.e('Erro ao atualizar item do ambiente: $e');
      rethrow;
    }
  }

  // Prepara os dados para salvar no Firebase
  Map<String, dynamic> toMap() {
    final visitaMap = _technicalVisit.toMap();
    visitaMap['ambientes'] = _environments.map((e) => e.toMap()).toList();
    return visitaMap;
  }

  // Carrega uma visita técnica existente
  factory TechnicalVisitManager.fromMap(Map<String, dynamic> map) {
    try {
      final visitaTecnica = TechnicalVisitObject.fromMap(map);
      final manager = TechnicalVisitManager(
        date: visitaTecnica.date,
        time: visitaTecnica.time,
        customer: visitaTecnica.customer,
      );

      if (map['enviroment'] != null) {
        final ambientes = (map['enviroment'] as List<dynamic>)
            .map((e) => EnviromentObject.fromMap(e as Map<String, dynamic>))
            .toList();
        // Adiciona cada ambiente individualmente
        for (final ambiente in ambientes) {
          manager.addEnvironment(
            id: ambiente.id,
            name: ambiente.name,
            description: ambiente.descroiption,
            metragem: ambiente.metragem,
            difficulty: ambiente.difficulty,
            observation: ambiente.observation,
            itens: ambiente.itens,
          );
        }
      }
      return manager;
    } catch (e) {
      Logger().e('Erro ao criar TechnicalVisitManager from Map: $e');
      rethrow;
    }
  }

  // Valida se a visita está pronta para ser salva
  bool validateForSave() {
    if (_environments.isEmpty) {
      throw Exception('A visita técnica deve ter pelo menos um ambiente');
    }

    for (final ambiente in _environments) {
      if (!ambiente.isValid()) {
        throw Exception('Ambiente inválido encontrado: ${ambiente.id}');
      }
    }

    return true;
  }

  // Obtém um ambiente específico
  EnviromentObject? getEnviroment(String id) {
    try {
      return _environments.firstWhere((env) => env.id == id);
    } catch (e) {
      return null;
    }
  }

  // Verifica se um ambiente existe
  bool hasEnviroment(String id) {
    return _environments.any((env) => env.id == id);
  }
}
