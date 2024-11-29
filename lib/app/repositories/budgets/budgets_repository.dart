import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';

abstract class BudgetsRepository {

  Future<void> saveBudget(String id, CustomerObject customer, DateTime date, String? observation, String value, bool status);
  Future<List<BudgetsObject>> getAllBudgets();
}