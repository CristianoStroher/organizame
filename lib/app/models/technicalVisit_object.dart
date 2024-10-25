import 'package:intl/intl.dart';

import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitObject {
  final String? id;
  final DateTime date;
  final DateTime time;
  final CustomerObject customer;
  /* final List<EnviromentObject>? ambientes; */

  TechnicalVisitObject({
    this.id,
    required this.date,
    required this.time,
    required this.customer,
    /* this.ambientes, */
  });

  factory TechnicalVisitObject.fromMap(Map<String, dynamic> map) {
    try {
      final dateStr = map['date'] as String?;
      final timeStr = map['time'] as String?;

      if (dateStr == null || timeStr == null) {
        throw ArgumentError('Campos obrigatórios ausentes');
      }

      final date = DateTime.parse(dateStr);
      final time = DateFormat('HH:mm:ss').parse(timeStr);

      final combinedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute, time.second);

      return TechnicalVisitObject(
        id: map['id'] as String?,
        date: date,
        time: combinedDateTime,
        customer: CustomerObject.fromMap(map['customer'] as Map<String, dynamic>),
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

  get customers => null;

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'time': DateFormat('HH:mm:ss').format(time),
        'customer': customer.toMap(),
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
        date: date ?? this.date,
        time: time ?? this.time,
        customer: customer ?? this.customer,
        /* ambientes: ambientes ?? ambientes ?? [], */
      );
    }

    @override
    String toString() {
      /* return 'TechnicalVisitObject(id: $id, date: $data, customer: $cliente, enviroments: $ambientes)'; */
      return 'TechnicalVisitObject(id: $id, date: $date, time: $time, customer: $customer)';
    }
  }

