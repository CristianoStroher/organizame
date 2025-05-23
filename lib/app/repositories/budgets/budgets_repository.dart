import 'package:organizame/app/models/budgets_object.dart';

abstract class BudgetsRepository {

  Future<void> saveBudget(BudgetsObject budget);
  Future<List<BudgetsObject>> getAllBudgets();
  Future<void> deleteBudget(String id);
  Future<void> updateBudget(BudgetsObject budget);
}