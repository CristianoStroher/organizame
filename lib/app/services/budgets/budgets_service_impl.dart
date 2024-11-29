// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/repositories/budgets/budgets_repository.dart';

import './budgets_service.dart';

class BudgetsServiceImpl extends BudgetsService {
  final BudgetsRepository _budgetsRepository;

  BudgetsServiceImpl({
    required BudgetsRepository budgetsRepository,
  }) : _budgetsRepository = budgetsRepository;

  @override
  Future<void> saveBudget(String id, CustomerObject customer, DateTime date, String? observation, String value, bool status) {
    return _budgetsRepository.saveBudget(id, customer, date, observation, value, status);
  }

  @override
  Future<List<BudgetsObject>> getAllBudgets() {
    return _budgetsRepository.getAllBudgets();
  }

}
