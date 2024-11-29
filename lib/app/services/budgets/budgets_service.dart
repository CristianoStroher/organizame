import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';

abstract class BudgetsService {

  Future<void> saveBudget(BudgetsObject budget);
  Future<List<BudgetsObject>> getAllBudgets();

}