// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

class BudgetsObject {

  final String id;
  final Customer customer;
  final DateTime date;
  final String? observation;
  final double value;
  final bool status;

  BudgetsObject({
    required this.id,    
    required this.customer,
    required this.date,
    this.observation,
    required this.value,
    required this.status,
  });

  factory BudgetsObject.fromJson(Map<String, dynamic> json) {
    return BudgetsObject(
      id: json['id'] as String,
      customer: json['customer'] as Customer,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      observation: json['observation'] as String?,
      value: json['value'] as double,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer': customer,
        'date': date.toIso8601String(),
        'observation': observation,
        'value': value,
        'status': status,
      };

  BudgetsObject copyWith({
    String? id,
    Customer? customer,
    DateTime? date,
    String? observation,
    double? value,
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
