import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';

class ChildBedroomController extends DefautChangeNotifer {
  final TechnicalVisitController _technicalVisitController;

  ChildBedroomController({required TechnicalVisitController technicalVisitController})
      : _technicalVisitController = technicalVisitController;

  Future<EnviromentObject> saveEnvironment({
    required String description,
    required String metragem,
    required String? difficulty,
    required String? observation,
    required Map<EnviromentItensEnum, bool> selectedItens,
  }) async {
    try {
      showLoadingAndResetState();

      final environment = EnviromentObject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Quarto Criança',
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
      );

      await _technicalVisitController.addEnvironment(environment);

      success();
      return environment;
    } catch (e) {
      setError('Erro ao salvar ambiente: $e');
      Logger().e('Erro ao salvar ambiente: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}