import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';

class LivingRoomController extends DefautChangeNotifer {
  final TechnicalVisitController _controller;

  LivingRoomController({required TechnicalVisitController controller})
      : _controller = controller {
        _controller.ensureCurrentVisit();
  }

  Future<EnviromentObject> saveEnvironment({
    required String description,
    required String metragem,
    required String? difficulty,
    required String? observation,
    required Map<String, bool> selectedItens,
  }) async {
    try {
      showLoadingAndResetState();
      Logger().d('ChildBedroomController construído com visita: ${_controller.currentVisit?.id}');
      final environment = EnviromentObject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Quarto de Casal',
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
      );

      if (_controller.currentVisit == null) {
        throw Exception('Visita não selecionada no controller');
      }

      await _controller.addEnvironment(environment);

      success();
      return environment;
    } catch (e) {
      setError('Erro ao salvar ambiente: $e');
      Logger().e('Erro ao salvar ambiente: $e');
      Logger().e('Estado do controller: ${_controller.currentVisit?.id}');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> updateEnvironment(EnviromentObject environment) async {
    try {
      Logger().d('ChildBedroomController - Iniciando atualização do ambiente');
      await _controller.updateEnvironment(environment);
      Logger().d('ChildBedroomController - Ambiente atualizado com sucesso');
    } catch (e) {
      Logger().e('ChildBedroomController - Erro ao atualizar ambiente: $e');
      rethrow;
    }
  }



  
}