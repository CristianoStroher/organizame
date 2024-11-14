import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/task_object.dart';
import 'package:organizame/app/modules/homeTasks/home_controller.dart';
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

 Future<void> saveTask(
    String description, 
    String date, 
    String time,
    String observationsEC
  ) async {
    try {
      showLoadingAndResetState();
      
      // Parse da data e hora a partir das strings recebidas
      final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      final DateTime parsedTime = DateFormat('HH:mm').parse(time);

      // Atualiza os valores selecionados
      _selectedDate = parsedDate;
      _selectedTime = parsedTime;

      if (description.isEmpty) {
        setError('Descrição é obrigatória');
        return;
      }

      if (_selectedDate == null || _selectedTime == null) {
        setError('Data e hora são obrigatórios');
        return;
      }

      await _tasksService.saveTask(
        _selectedDate!,
        _selectedTime!,
        description,
        observations: observationsEC,
      );

      success();
      
      // Limpa os valores após salvar
      _selectedDate = null;
      _selectedTime = null;
      
    } catch (e) {
      Logger().e('Erro ao salvar tarefa: $e');
      setError('Erro ao salvar tarefa');
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
      
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskObject task) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _tasksService.updateTask(task); // Chama o método no serviço
      success();
    } catch (e, s) {
      setError('Erro ao atualizar tarefa');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
