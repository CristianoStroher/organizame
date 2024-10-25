import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitController extends DefautChangeNotifer {

  final TechnicalVisitService _technicalVisitService;
  List<TechnicalVisitObject> _technicalVisits = [];
  TechnicalVisitObject? currentVisit;
  List<EnviromentObject> currentEnvironments = [];

  TechnicalVisitController({
    required TechnicalVisitService technicalVisitService,
  }) : _technicalVisitService = technicalVisitService;

  Future<void> saveTechnicalVisit(
      DateTime date, DateTime time, CustomerObject customer) async {
    try {
      showLoadingAndResetState();

      final newTechnicalVisit = TechnicalVisitObject(
        date: date,
        time: time,
        customer: customer,
      );

      await _technicalVisitService.saveTechnicalVisit(date, time, customer);
      Logger().i('Visita técnica salva com sucesso: $newTechnicalVisit');
      success();
    } catch (e) {
      Logger().e('Erro ao salvar visita técnica: $e');
      setError('Erro ao salvar visita técnica: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}