// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  factory BudgetsObject.fromMap(Map<String, dynamic> json) {
    return BudgetsObject(
      id: json['id'] as String,
      customer: json['customer'] as CustomerObject,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      observation: json['observation'] as String?,
      value: json['value'] as String,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'customer': customer,
        'date': date.toIso8601String(),
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
