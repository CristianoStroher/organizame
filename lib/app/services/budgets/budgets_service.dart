import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

abstract class BudgetsService {

  Future<void> saveBudget(String id, Customer customer, DateTime date, String? observation, double value, bool status);
  Future<List<BudgetsObject>> getAllBudgets();

}