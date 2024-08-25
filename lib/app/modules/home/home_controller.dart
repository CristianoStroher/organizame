import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/task_filter_enum.dart';

class HomeController extends DefautChangeNotifer {
  var filterSelected = TaskFilterEnum.today;

  HomeController() {
    hideLoading();
  }
}
