import 'package:intl/intl.dart';

import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';

class TechnicalVisitObject {
  final String? id;
  final DateTime date;
  final DateTime time;
  final CustomerObject customer;
  final List<EnviromentObject>? enviroment;

  TechnicalVisitObject({
    this.id,
    required this.date,
    required this.time,
    required this.customer,
    List<EnviromentObject>? enviroment,
  }) : enviroment = enviroment ?? [];

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
        enviroment: map['ambientes'] != null
            ? (map['ambientes'] as List<dynamic>)
                .map((e) => EnviromentObject.fromMap(e as Map<String, dynamic>))
                .toList()
            : [],
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
        'ambientes': enviroment?.map((e) => e.toMap()).toList(),
      };
    }

    TechnicalVisitObject copyWith({
      String? id,
      DateTime? date,
      DateTime? time,
      CustomerObject? customer,
      List<EnviromentObject>? enviroment,
    }) {
      return TechnicalVisitObject(
        id: id ?? this.id,
        date: date ?? this.date,
        time: time ?? this.time,
        customer: customer ?? this.customer,
        enviroment: enviroment ?? this.enviroment,
      );
    }

    @override
    String toString() {
      return 'TechnicalVisitObject(id: $id, date: $date, time: $time, customer: $customer enviroments: $enviroment)';
    }
  }

