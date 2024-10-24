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
      DateTime data, DateTime hora, CustomerObject cliente) async {
    try {
      showLoadingAndResetState();

      final newTechnicalVisit = TechnicalVisitObject(
        data: data,
        hora: hora,
        cliente: cliente,
      );

      await _technicalVisitService.saveTechnicalVisit(data, hora, cliente);
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