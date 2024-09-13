import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/modules/home/home_controller.dart';
import 'package:organizame/app/services/tasks/tasks_service.dart';

class TaskController extends DefautChangeNotifer {
  final TasksService _tasksService;

  DateTime? _selectedDate;
  DateTime? _selectedTime;

  TaskController({
    required TasksService tasksService,
  })  : _tasksService = tasksService,
        super() {
    resetState();
  }

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

  Future<void> saveTask(String description, String date, String time,
      String observationsEC) async {
    try {
      showLoadingAndResetState();
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
        success();
        setSelectedDate = null;
        setSelectedTime = null;
        // Logger().e('tarefa salva');
      } else {
        setError('Data e hora são obrigatórios');
      }
    } catch (e, s) {
      setError('Erro ao salvar tarefa');
      // Logger().e(e);
      // Logger().e(s);
    } finally {
      hideLoading();
      notifyListeners();
      
    }

  }  

  Future<void> updateTask(TaskObject task) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _tasksService.updateTask(task);

      success();
    } catch (e, s) {
      setError('Erro ao atualizar tarefa');
      // Logger().e(e);
      // Logger().e(s);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> findTask(TaskObject task) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _tasksService.findTask(task);
      success();
    } catch (e, s) {
      setError('Erro ao buscar tarefa');
      // Logger().e(e);
      // Logger().e(s);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
