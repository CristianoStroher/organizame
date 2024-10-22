import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';

class TechnicalVisitObject {
  final String id;
  final DateTime date;
  final DateTime time;
  final CustomerObject customer;
  final List<EnviromentObject>? enviroments;

  TechnicalVisitObject({
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    this.enviroments,
  });

  factory TechnicalVisitObject.fromMap(Map<String, dynamic> map) {
    return TechnicalVisitObject(
      id: map['id'] as String,
      date: (map['data'] as Timestamp).toDate(),
      time: (map['hora'] as Timestamp).toDate(),
      customer: CustomerObject.fromMap(map['cliente'] as Map<String, dynamic>),
      enviroments: map['ambientes'] != null
          ? (map['ambientes'] as List<dynamic>)
              .map((e) => EnviromentObject.fromMap(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  factory TechnicalVisitObject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return TechnicalVisitObject.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': DateFormat('yyyy-MM-dd').format(date),
      'hora': DateFormat('HH:mm:ss').format(time),
      'cliente': customer.toMap(),
      'ambientes': enviroments?.map((e) => e.toMap()).toList(),
    };
  }

  TechnicalVisitObject copyWith({
    String? id,
    DateTime? date,
    DateTime? time,
    CustomerObject? customer,
    List<EnviromentObject>? enviroments,
  }) {
    return TechnicalVisitObject(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      customer: customer ?? this.customer,
      enviroments: enviroments ?? enviroments ?? [],
    );
  }

  @override
  String toString() {
    return 'TechnicalVisitObject(id: $id, date: $date, customer: $customer, enviroments: $enviroments)';
  }

  bool isValid() {
    return id.isNotEmpty &&
        customer.name.isNotEmpty &&
        customer.name.isNotEmpty;
  }
}
