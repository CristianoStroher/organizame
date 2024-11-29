// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

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

  // metodo para converter de Map para BudgetsObject
  factory BudgetsObject.fromMap(Map<String, dynamic> map) {
    try {
      return BudgetsObject(
        id: map['id'] as String,
        customer:
            CustomerObject.fromMap(map['customer'] as Map<String, dynamic>),
        date:
            map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
        observation: map['observation'] as String?,
        value: map['value'] as String,
        status: map['status'] as bool,
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para BudgetsObject: $e');
      rethrow;
    }
  }

  // metodo para converter de BudgetsObject para Map
  Map<String, dynamic> toMap() => {
        'id': id,
        'customer': customer.toMap(),
        'date': Timestamp.fromDate(date),
        'observation': observation,
        'value': value,
        'status': status,
      };

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
