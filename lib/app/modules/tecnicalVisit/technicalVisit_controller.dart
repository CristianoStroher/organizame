import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitController extends DefautChangeNotifer {
  final TechnicalVisitService _technicalVisitService;

  bool _isSuccess = false;
  bool get hasSuccess => _isSuccess;

  List<TechnicalVisitObject> _technicalVisits = [];
  TechnicalVisitObject? currentVisit;
  List<EnviromentObject> currentEnvironments = [];

  TechnicalVisitController({
    required TechnicalVisitService technicalVisitService,
  }) : _technicalVisitService = technicalVisitService;

  /// Reset _isSuccess to ensure a clean state between operations.
  void _resetSuccessState() {
    _isSuccess = false;
  }

  Future<void> loadAllVisits() async {
    try {
      _resetSuccessState(); // Reset success state
      showLoadingAndResetState();
      
      final visits = await _technicalVisitService.getAllTechnicalVisits();

      if (visits != _technicalVisits) { 
        _technicalVisits = visits;
        notifyListeners();
      }
      
      hideLoading();
    } on Exception catch (e) {
      Logger().e('Erro ao buscar as visitas técnicas: $e');
      setError('Erro ao buscar as visitas técnicas: $e');
    }
  }

  Future<void> saveTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    if (currentVisit == null) {
      setError('Nenhuma visita para salvar');
      return;
    }

    try {
      _resetSuccessState(); 
      showLoadingAndResetState();

      final visitToSave = currentVisit!.copyWith(enviroments: currentEnvironments);

      await _technicalVisitService.saveTechnicalVisit(visitToSave);

      _isSuccess = true;

      
      currentVisit = null;
      currentEnvironments.clear();

      
      await loadAllVisits();
    } catch (e) {
      _isSuccess = false;
      Logger().e('Erro ao salvar visita técnica: $e');
      setError('Erro ao salvar visita técnica: $e');
    }
  }

  void initNewVisit() {
    _resetSuccessState(); 

    currentVisit = TechnicalVisitObject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      time: DateTime.now(),
      customer: CustomerObject(id: '', name: ''),
      enviroments: [],
    );
    currentEnvironments.clear();
    notifyListeners();
  }

 
  void addEnvironment(EnviromentObject newEnvironment) {
    if (newEnvironment.isValid()) { // Assume isValid() checks for validity
      currentEnvironments.add(newEnvironment);
      notifyListeners(); 
    } else {
      Logger().e('Ambiente inválido: ${newEnvironment.toString()}');
      setError('Ambiente inválido');
    }
  }

  void updateVisitDetails({
    CustomerObject? customer,
    DateTime? date,
    DateTime? time,
  }) {
    if (currentVisit != null) {
      final updatedVisit = currentVisit!.copyWith(
        customer: customer ?? currentVisit!.customer,
        date: date ?? currentVisit!.date,
        time: time ?? currentVisit!.time,
      );

      if (updatedVisit != currentVisit) { 
        currentVisit = updatedVisit;
        notifyListeners(); // Notify only if something changed
      }
    }
  }

  List<TechnicalVisitObject> get technicalVisits => _technicalVisits;
  bool get hasCurrentVisits => currentVisit != null;
}
