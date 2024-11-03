// ignore_for_file: public_member_api_docs, sort_constructors_first

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
        throw Exception('Ambiente inválido: $environment - campos obrigatórios não preenchidos');
      }

      _environments.add(environment);
    } catch (e) {
      _logger.e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  
  


  
}
