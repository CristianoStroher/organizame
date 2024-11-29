// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';

class BudgetsObject {

  final String id;
  final CustomerObject customer;
  final DateTime date;
  final String? observation;
  final String value;
  final bool status;

  BudgetsObject({
    required this.id,    
    required this.customer,
    required this.date,
    this.observation,
    required this.value,
    required this.status,
  });

  // metodo para converter de BudgetsObject para Map
  Map<String, dynamic> toMap() => {
        'customer': customer.toMap(), // Note a mudança aqui para usar toMap()
        'date': Timestamp.fromDate(date),
        'observation': observation,
        'value': value,
        'status': status,
    };
 
  // metodo para converter de Map para BudgetsObject
  factory BudgetsObject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetsObject(
      id: doc.id,
      customer: CustomerObject.fromMap(data['customer'] as Map<String, dynamic>),
      date: (data['date'] as Timestamp).toDate(),
      observation: data['observation'] as String?,
      value: data['value'] as String,
      status: data['status'] as bool,
    );
  }

  factory BudgetsObject.fromMap(Map<String, dynamic> map) {
    try {
      return BudgetsObject(
        id: map['id'] as String,
        customer: CustomerObject.fromMap(map['customer'] as Map<String, dynamic>),
        date: map['date'] is Timestamp 
            ? (map['date'] as Timestamp).toDate()
            : DateTime.parse(map['date']),
        observation: map['observation'] as String?,
        value: map['value'] as String,
        status: map['status'] as bool,
      );
    } catch (e) {
      throw Exception('Erro ao converter map para BudgetsObject: $e');
    }
  }

  BudgetsObject copyWith({
    String? id,
    CustomerObject? customer,
    DateTime? date,
    String? observation,
    String? value,
    bool? status,
  }) {
    return BudgetsObject(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      observation: observation ?? this.observation,
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'BudgetsObject{id: $id, customer: $customer, date: $date, observation: $observation, value: $value, status: $status}';
  }

}
