// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

class BudgetsObject {

  final String id;
  final Customer customer;
  final DateTime date;
  final String? observation;
  final int value;
  final bool status;

  BudgetsObject({
    required this.id,    
    required this.customer,
    required this.date,
    this.observation,
    required this.value,
    required this.status,
  });

}
