import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitController extends DefautChangeNotifer {
  final TechnicalVisitService _technicalVisitService;

  List<TechnicalVisitObject> _technicalVisits = []; // Lista de visitas técnicas
  TechnicalVisitObject? currentVisit; // Visita técnica atual
  List<EnviromentObject> currentEnvironments = []; // Lista de ambientes atuais

  TechnicalVisitController({required TechnicalVisitService technicalVisitService})
      : _technicalVisitService = technicalVisitService;


  // função para carregar todas as visitas técnicas
  Future<void> loadAllVisit() async {
    try {
      showLoadingAndResetState();
      _technicalVisits = await _technicalVisitService.getAllTechnicalVisits();
      hideLoading();
      notifyListeners();
    } on Exception catch (e) {
      setError('Erro ao buscar as visitas técnicas: $e');
    }
  }

  // função para criar uma nova visita técnica
  Future<void> createTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      showLoadingAndResetState();
      await _technicalVisitService.createTechnicalVisit(technicalVisit);
      hideLoading();
      success();
      await loadAllVisit();
    } catch (e) {
      setError('Erro ao criar nova visita técnica: $e');
    }
  }

  // função para adicionar um ambiente a visita técnica
  void initNewVisit() {
    currentVisit = TechnicalVisitObject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      time: DateTime.now(),
      customer: CustomerObject(id: '', name: ''), // Cliente vazio
      enviroments: [],
    );
    currentEnvironments.clear();
    notifyListeners();
  }

  void addEnvironment(EnviromentObject newEnvironment) {}
}
