// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';

class BudgetsController extends DefautChangeNotifer {
  
    final BudgetsService _service;
  
  BudgetsController({
    required BudgetsService service,
  }) : _service = service;

  Future<List<BudgetsObject>> getAllBudgets() {
    return FirebaseFirestore.instance.collection('budgets').get().then(
        (value) =>
            value.docs.map((e) => BudgetsObject.fromMap(e.data())).toList());
  }

  
}
