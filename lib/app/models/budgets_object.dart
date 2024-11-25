// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

class BudgetsObject {
    
  final String id;
  final Customer customer;
  final String date;
  final String? observation;
  final int value;
  final String status;

  BudgetsObject({
    required this.id,    
    required this.customer,
    required this.date,
    this.observation,
    required this.value,
    required this.status,
  });

}
