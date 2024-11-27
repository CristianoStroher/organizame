// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';

class BudgetsController extends DefautChangeNotifer {
  
    final BudgetsService _service;
  
  BudgetsController({
    required BudgetsService service,
  }) : _service = service;

  
}
