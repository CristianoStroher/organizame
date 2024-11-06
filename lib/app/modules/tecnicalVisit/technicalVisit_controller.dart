import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitController extends DefautChangeNotifer {
  final TechnicalVisitService _service;
  List<TechnicalVisitObject> _technicalVisits = [];
  TechnicalVisitObject? currentVisit;
  List<EnviromentObject> currentEnvironments = [];
  final Logger _logger = Logger();

  TechnicalVisitController({
    required TechnicalVisitService service,
  }) : _service = service;

  Future<void> saveTechnicalVisit(
      DateTime date, DateTime time, CustomerObject customer) async {
    try {
      showLoadingAndResetState();

      final newTechnicalVisit = TechnicalVisitObject(
        date: date,
        time: time,
        customer: customer,
      );

      await _service.saveTechnicalVisit(date, time, customer);

      // Busca todas as visitas para obter a que acabou de ser salva
      final allVisits = await _service.getAllTechnicalVisits();
      _technicalVisits = allVisits;

      // Encontra a visita recém salva e atualiza currentVisit
      currentVisit = allVisits.firstWhere((visit) =>
          visit.date.day == date.day &&
          visit.date.month == date.month &&
          visit.date.year == date.year &&
          visit.time.hour == time.hour &&
          visit.time.minute == time.minute &&
          visit.customer.id == customer.id);

      Logger().d('Visita salva e definida como atual: ${currentVisit?.id}');

      success();
    } catch (e) {
      _logger.i('Erro ao salvar visita técnica: $e');
      setError('Função save - Erro ao salvar visita técnica: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> updateVisit(TechnicalVisitObject visit) async {
    try {
      if (visit.id == null) {
        Logger().e('Tentativa de atualizar visita sem ID');
        throw Exception('Não é possível atualizar uma visita sem ID');
      }

      showLoadingAndResetState();
      Logger().i('Iniciando atualização da visita: ${visit.id}');

      // Atualiza no serviço
      await _service.updateTechnicalVisit(visit);
      Logger().i('Visita atualizada com sucesso: ${visit.id}');

      // Atualiza na lista local se existir
      final index = _technicalVisits.indexWhere((v) => v.id == visit.id);
      if (index != -1) {
        _technicalVisits[index] = visit;
      }

      await refreshVisits();

      success();
    } catch (e) {
      final errorMsg = 'Erro ao atualizar visita técnica: $e';
      Logger().e(errorMsg);
      setError(errorMsg);
      throw Exception(errorMsg);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  // Método auxiliar para buscar uma visita pelo ID
  Future<TechnicalVisitObject?> findVisitById(String id) async {
    try {
      return _technicalVisits.firstWhere((v) => v.id == id);
    } catch (e) {
      Logger().w('Visita não encontrada: $id');
      return null;
    }
  }

  // Método para recarregar a lista de visitas
  Future<void> refreshVisits() async {
    try {
      showLoadingAndResetState();
      Logger().i('Recarregando lista de visitas');

      _technicalVisits = await _service.getAllTechnicalVisits();

      // Se estiver editando uma visita, atualiza a currentVisit
      if (currentVisit != null) {
        currentVisit = _technicalVisits.firstWhere(
          (visit) => visit.id == currentVisit!.id,
          orElse: () => currentVisit!,
        );
      }

      success();
    } catch (e) {
      final errorMsg = 'Erro ao recarregar visitas: $e';
      Logger().e(errorMsg);
      setError(errorMsg);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  // Método para carregar uma visita existente
  void loadExistingVisit(TechnicalVisitObject visit) {
    currentVisit = visit;
    notifyListeners();
  }

  //metodo para verificar se pode acionar o botão de adicionar ambientes
  bool canAddEnvironments() {
    return currentVisit?.id != null;
  }

  Future<void> addEnvironment(EnviromentObject environment) async {
    try {
      Logger().i('Iniciando adição do ambiente à visita');
      Logger().d('Ambiente: ${environment.toString()}');

      if (currentVisit == null) {
        throw Exception('Nenhuma visita selecionada');
      }

      // Adiciona à lista local
      currentEnvironments.add(environment);

      // Atualiza a visita
      final updatedVisit = currentVisit!.copyWith(
        enviroment: List.from(currentEnvironments),
      );

      Logger().d('Visita atualizada: ${updatedVisit.toString()}');

      // Salva no banco
      await updateVisit(updatedVisit);

      Logger().i('Ambiente adicionado com sucesso');
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }
}
