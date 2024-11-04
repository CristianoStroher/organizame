import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';

import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';

class TechnicalVisitManager {
  TechnicalVisitObject _technicalVisit;
  final List<EnviromentObject> _enviroments = [];
  final Logger _logger = Logger();

  TechnicalVisitManager({
    required DateTime date,
    required DateTime time,
    required CustomerObject customer,
  }) : _technicalVisit = TechnicalVisitObject(
          date: date,
          time: time,
          customer: customer,
          enviroment: [], // Inicializa com lista vazia
        );

  // Getters
  TechnicalVisitObject get visitaTecnica => _technicalVisit.copyWith(
        enviroment: List.unmodifiable(_enviroments),
      );
  List<EnviromentObject> get enviroments => List.unmodifiable(_enviroments);

  // Atualiza dados básicos da visita
  void updateVisitData({
    DateTime? date,
    DateTime? time,
    CustomerObject? customer,
  }) {
    _technicalVisit = _technicalVisit.copyWith(
      date: date,
      time: time,
      customer: customer,
    );
  }

  // Adiciona um ambiente
  void addEnviroment({
    required String id,
    required String name,
    required String description,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    try {
      final enviroment = EnviromentObject(
        id: id,
        name: name,
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: itens,
      );

      if (!enviroment.isValid()) {
        throw Exception('Ambiente inválido: campos obrigatórios não preenchidos');
      }

      _enviroments.add(enviroment);
      _logger.i('Ambiente adicionado: ${enviroment.name}');
    } catch (e) {
      _logger.e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  // Remove um ambiente
  void removeEnviroment(String enviromentId) {
    try {
      final enviroment = _enviroments.firstWhere(
        (env) => env.id == enviromentId,
        orElse: () => throw Exception('Ambiente não encontrado: $enviromentId'),
      );
      
      _enviroments.remove(enviroment);
      _logger.i('Ambiente removido: $enviromentId');
    } catch (e) {
      _logger.e('Erro ao remover ambiente: $e');
      rethrow;
    }
  }

  // Atualiza um ambiente existente
  void updateEnviroment({
    required String id,
    String? name,
    String? description,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    try {
      final index = _enviroments.indexWhere((env) => env.id == id);
      if (index == -1) {
        throw Exception('Ambiente não encontrado: $id');
      }

      final enviromentAtual = _enviroments[index];
      final enviromentAtualizado = enviromentAtual.copyWith(
        name: name,
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: itens,
      );

      if (!enviromentAtualizado.isValid()) {
        throw Exception('Atualização inválida: campos obrigatórios não preenchidos');
      }

      _enviroments[index] = enviromentAtualizado;
      _logger.i('Ambiente atualizado: ${enviromentAtualizado.name}');
    } catch (e) {
      _logger.e('Erro ao atualizar ambiente: $e');
      rethrow;
    }
  }


  // Prepara os dados para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      ..._technicalVisit.toMap(),
      'ambientes': _enviroments.map((e) => e.toMap()).toList(),
    };
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

      if (visitaTecnica.enviroment != null) {
        for (final enviroment in visitaTecnica.enviroment!) {
          manager.addEnviroment(
            id: enviroment.id,
            name: enviroment.name,
            description: enviroment.descroiption,
            metragem: enviroment.metragem,
            difficulty: enviroment.difficulty,
            observation: enviroment.observation,
            itens: enviroment.itens,
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
    if (_enviroments.isEmpty) {
      throw Exception('A visita técnica deve ter pelo menos um ambiente');
    }

    for (final enviroment in _enviroments) {
      if (!enviroment.isValid()) {
        throw Exception('Ambiente inválido encontrado: ${enviroment.id}');
      }
    }

    return true;
  }

  // Obtém um ambiente específico
  EnviromentObject? getEnviroment(String id) {
    try {
      return _enviroments.firstWhere((env) => env.id == id);
    } catch (e) {
      return null;
    }
  }

  // Verifica se um ambiente existe
  bool hasEnviroment(String id) {
    return _enviroments.any((env) => env.id == id);
  }
}
