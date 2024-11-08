import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';

class ChildBedroomController extends DefautChangeNotifer {
  final TechnicalVisitController _technicalVisitController;

  ChildBedroomController({required TechnicalVisitController technicalVisitController})
      : _technicalVisitController = technicalVisitController {
        _technicalVisitController.ensureCurrentVisit();
  }

  Future<EnviromentObject> saveEnvironment({
    required String description,
    required String metragem,
    required String? difficulty,
    required String? observation,
    required Map<EnviromentItensEnum, bool> selectedItens,
  }) async {
    try {
      showLoadingAndResetState();
      Logger().d('ChildBedroomController construído com visita: ${_technicalVisitController.currentVisit?.id}');
      final environment = EnviromentObject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Quarto Criança',
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
      );

      if (_technicalVisitController.currentVisit == null) {
        throw Exception('Visita não selecionada no controller');
      }

      await _technicalVisitController.addEnvironment(environment);

      success();
      return environment;
    } catch (e) {
      setError('Erro ao salvar ambiente: $e');
      Logger().e('Erro ao salvar ambiente: $e');
      Logger().e('Estado do controller: ${_technicalVisitController.currentVisit?.id}');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}