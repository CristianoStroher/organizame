// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';

class BudgetsCreateController extends DefautChangeNotifer {
  final BudgetsService _service;

  BudgetsCreateController({
    required BudgetsService service,
  }) : _service = service;

  Future<void> saveBudget(String id, Customer customer, DateTime date,
      String? observation, double value, bool status) {
    return _service.saveBudget(id, customer, date, observation, value, status);
  }

  Future<List<BudgetsObject>> getAllBudgets() {
    return FirebaseFirestore.instance.collection('budgets').get().then(
        (value) =>
            value.docs.map((e) => BudgetsObject.fromMap(e.data())).toList());
  }
}
