import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';

class TaskController extends DefautChangeNotifer {

  final TasksService _tasksService;
  
  DateTime? _selectedDate;
  DateTime? _selectedTime;

  TaskController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  set setSelectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  set setSelectedTime(DateTime? selectedTime) {
    _selectedTime = selectedTime;
    notifyListeners();
  }

  DateTime? get getSelectedDate => _selectedDate;
  DateTime? get getSelectedTime => _selectedTime;


  // Getter para a data selecionada
  DateTime? get selectedDate => _selectedDate;

  // Getter para a hora selecionada
  DateTime? get selectedTime => _selectedTime;

}
