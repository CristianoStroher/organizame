import 'package:logger/logger.dart';
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
    resetState();
    notifyListeners();
  }

  set setSelectedTime(DateTime? selectedTime) {
    _selectedTime = selectedTime;
    resetState();
    notifyListeners();
  }

  DateTime? get getSelectedDate => _selectedDate;
  DateTime? get getSelectedTime => _selectedTime;

  // Getter para a data selecionada
  DateTime? get selectedDate => _selectedDate;

  // Getter para a hora selecionada
  DateTime? get selectedTime => _selectedTime;

  Future<void> saveTask(String description, String date, String time, String observationsEC) async {
    try {
      showLoadingAndReset();
      notifyListeners();
      if (_selectedDate != null ||
          _selectedTime != null ||
          description.isNotEmpty) {
        await _tasksService.saveTask(
          _selectedDate!,
          _selectedTime!,
          description,
          observations: observationsEC,
        );
        sucess();
        setSelectedDate = null;
        setSelectedTime = null;                      
                     
      } else {
        setError('Data e hora são obrigatórios');
      }
      hideLoading();
    } catch (e, s) {
      setError('Erro ao salvar tarefa');
      Logger().e(e);
      Logger().e(s);
    } finally {
      hideLoading();
      notifyListeners();
      
    }
  }
}

