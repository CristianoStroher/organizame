// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';

class BudgetsCreateController extends DefautChangeNotifer {
  final BudgetsService _service;

  BudgetsCreateController({
    required BudgetsService service,
  }) : _service = service;

  Future<bool> saveBudget(BudgetsObject budget) async {
  try {
    showLoadingAndResetState();
    await _service.saveBudget(budget);
    success();
    return true;
  } catch (e) {
    setError('Erro ao salvar orçamento');
    return false;
  }finally {
    hideLoading();
    notifyListeners();
  }
}

Future<List<BudgetsObject>> getAllBudgets() async {
    try {
      showLoadingAndResetState();
      final budgets = await _service.getAllBudgets();
      success();
      return budgets;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
