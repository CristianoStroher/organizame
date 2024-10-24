import 'package:intl/intl.dart';

import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';

class TechnicalVisitObject {
  final String? id;
  final DateTime data;
  final DateTime hora;
  final CustomerObject cliente;
  /* final List<EnviromentObject>? ambientes; */

  TechnicalVisitObject({
    this.id,
    required this.data,
    required this.hora,
    required this.cliente,
    /* this.ambientes, */
  });

  factory TechnicalVisitObject.fromMap(Map<String, dynamic> map) {
    try {
      final dateStr = map['data'] as String?;
      final timeStr = map['hora'] as String?;

      if (dateStr == null || timeStr == null) {
        throw ArgumentError('Campos obrigatórios ausentes');
      }

      final date = DateTime.parse(dateStr);
      final time = DateFormat('HH:mm:ss').parse(timeStr);

      final combinedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute, time.second);

      return TechnicalVisitObject(
        id: map['id'] as String?,
        data: date,
        hora: combinedDateTime,
        cliente: CustomerObject.fromMap(map['cliente'] as Map<String, dynamic>),
        /* ambientes: map['ambientes'] != null
            ? (map['ambientes'] as List<dynamic>)
                .map((e) => EnviromentObject.fromMap(e as Map<String, dynamic>))
                .toList()
            : [], */
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para TechnicalVisitObject: $e');
      rethrow;
    }

  }

  get customer => null;

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'data': DateFormat('yyyy-MM-dd').format(data),
        'hora': DateFormat('HH:mm:ss').format(hora),
        'cliente': cliente.toMap(),
        /* 'ambientes': ambientes?.map((e) => e.toMap()).toList(), */
      };
    }

    TechnicalVisitObject copyWith({
      String? id,
      DateTime? data,
      DateTime? hora,
      CustomerObject? cliente,
      /* List<EnviromentObject>? ambientes, */
    }) {
      return TechnicalVisitObject(
        id: id ?? this.id,
        data: data ?? this.data,
        hora: hora ?? this.hora,
        cliente: cliente ?? this.cliente,
        /* ambientes: ambientes ?? ambientes ?? [], */
      );
    }

    @override
    String toString() {
      /* return 'TechnicalVisitObject(id: $id, date: $data, customer: $cliente, enviroments: $ambientes)'; */
      return 'TechnicalVisitObject(id: $id, date: $data, customer: $cliente)';
    }
  }

