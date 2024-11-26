import 'package:organizame/app/modules/tecnicalVisit/customer/widget/customer.dart';

abstract class BudgetsRepository {

  Future<void> saveBudget(String id, Customer customer, DateTime date, String? observation, double value, bool status);

}