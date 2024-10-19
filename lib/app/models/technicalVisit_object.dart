import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object2.dart';

class TechnicalVisitObject {
  final String id;
  final DateTime date;
  final DateTime time;
  final CustomerObject customer;
  final List<EnviromentObject2>? enviroments;

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
      enviroments: (map['ambientes'] as List<dynamic>)
          .map((e) => EnviromentObject2.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory TechnicalVisitObject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TechnicalVisitObject.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': Timestamp.fromDate(date),
      'hora': Timestamp.fromDate(time),
      'cliente': customer.toMap(),
      'ambientes': enviroments?.map((e) => e.toMap()).toList(),
    };
  }

  TechnicalVisitObject copyWith({
    String? id,
    DateTime? data,
    DateTime? time,
    CustomerObject? customer,
    List<EnviromentObject2>? ambientes,
  }) {
    return TechnicalVisitObject(
      id: id ?? this.id,
      date: data ?? date,
      time: time ?? this.time,
      customer: customer ?? this.customer,
      enviroments: ambientes ?? enviroments ?? [],
    );
  }

  @override
  String toString() {
    return 'TechnicalVisitObject(id: $id, date: $date, customer: $customer, enviroments: $enviroments)';
  }

  bool isValid() {
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return id.isNotEmpty && !dateTime.isBefore(DateTime.now());
  }
}
