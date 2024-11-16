import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/environment/enviroment_page.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';
import 'package:organizame/app/models/customer_object.dart';

class TechnicalVisitController extends DefautChangeNotifer {
  EnviromentObject? get currentEnvironment => _currentEnvironment;
  EnviromentObject? _currentEnvironment;
  final TechnicalVisitService _service;
  List<TechnicalVisitObject> _technicalVisits = [];
  TechnicalVisitObject? currentVisit;
  List<EnviromentObject> currentEnvironments = [];
  final Logger _logger = Logger();
  String? _currentVisitId;

  TechnicalVisitController({
    required TechnicalVisitService service,
  }) : _service = service;

  Future<void> saveTechnicalVisit(
      DateTime date, DateTime time, CustomerObject customer) async {
    try {
      showLoadingAndResetState();
      Logger().d('Iniciando salvamento de visita técnica');

      await _service.saveTechnicalVisit(date, time, customer);

      // Atualiza a lista de visitas
      _technicalVisits = await _service.getAllTechnicalVisits();

      // Encontra a visita recém criada e define como atual
      currentVisit = _technicalVisits.firstWhere((visit) =>
          visit.date.day == date.day &&
          visit.date.month == date.month &&
          visit.date.year == date.year &&
          visit.time.hour == time.hour &&
          visit.time.minute == time.minute &&
          visit.customer.id == customer.id);

      _currentVisitId = currentVisit?.id;
      currentEnvironments = List.from(currentVisit?.enviroment ?? []);

      Logger().d('Visita salva e definida como atual: ${currentVisit?.id}');
      Logger().d('Pronta para receber ambientes');

      success();
      notifyListeners();
    } catch (e) {
      _logger.e('Erro ao salvar visita técnica: $e');
      setError('Erro ao salvar visita técnica');
      rethrow;
    } finally {
      hideLoading();
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

      // Atualiza lista principal
      _technicalVisits = await _service.getAllTechnicalVisits();

      // Se existe uma visita atual, atualiza ela também
      if (currentVisit != null) {
        final updatedVisit = _technicalVisits.firstWhere(
          (visit) => visit.id == currentVisit!.id,
          orElse: () => currentVisit!,
        );
        setCurrentVisit(updatedVisit);
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

  // Adicione um método para inicialização
  Future<void> initialize() async {
    try {
      showLoadingAndResetState();
      await refreshVisits();
    } catch (e) {
      Logger().e('Erro na inicialização: $e');
      setError('Erro ao carregar visitas');
    } finally {
      hideLoading();
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
      Logger()
          .d('Tentando adicionar ambiente. CurrentVisit: ${currentVisit?.id}');
      Logger().d('CurrentVisit: ${currentVisit?.id}'); // Novo log
      Logger().d('Ambiente: ${environment.toString()}');

      if (currentVisit?.id == null) {
        throw Exception('Nenhuma visita selecionada');
        Logger().e('CurrentVisit é null ao tentar adicionar ambiente');
      }

      // Chama o método específico no service
      await _service.addEnvironmentToVisit(currentVisit!.id!, environment);
      // Adiciona à lista local
      currentEnvironments.add(environment);

      final updatedVisit = currentVisit!.copyWith(
        enviroment: List.from(currentEnvironments),
      );

      Logger().d('Visita atualizada: ${updatedVisit.id}');

      await updateVisit(updatedVisit);
      await refreshVisits(); // Atualiza a lista após adicionar

      success();

      Logger().i('Ambiente adicionado com sucesso');
    } catch (e) {
      Logger().e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  List<EnviromentObject> get environments => currentEnvironments;

  Future<void> navigateToEnvironment(BuildContext context) async {
    Logger().d('Navegando para ambiente. CurrentVisit: ${currentVisit?.id}');

    if (currentVisit == null) {
      Logger().e('Tentando navegar sem visita selecionada');
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnviromentPage(
          technicalVisitController: this,
        ),
      ),
    );

    if (result == true) {
      await refreshVisits();
    }

    Logger()
        .d('Retornou da navegação. CurrentVisit ainda é: ${currentVisit?.id}');
  }

  void setCurrentVisit(TechnicalVisitObject visit) {
    Logger().d('Definindo visita atual: ${visit.id}');
    currentVisit = visit;
    _currentVisitId = visit.id;
    currentEnvironments = List.from(visit.enviroment ?? []);

    Logger().d('CurrentVisit definido com ID: $_currentVisitId');
    Logger().d('Ambientes carregados: ${currentEnvironments.length}');

    notifyListeners();
  }

  Future<void> ensureCurrentVisit() async {
    if (currentVisit == null && _currentVisitId != null) {
      currentVisit = await findVisitById(_currentVisitId!);
      Logger().d('CurrentVisit restaurado com ID: $_currentVisitId');
      notifyListeners();
    }
  }

  Future<void> removeEnvironment(String environmentId) async {
    try {
      if (currentVisit?.id == null) {
        throw Exception('Nenhuma visita selecionada');
      }

      Logger().d('Iniciando remoção do ambiente: $environmentId');
      Logger().d('Da visita: ${currentVisit!.id}');

      // Remove do backend
      await _service.removeEnvironmentFromVisit(
          currentVisit!.id!, environmentId);

      // Remove da lista local
      currentEnvironments.removeWhere((env) => env.id == environmentId);

      // Atualiza a visita atual
      final updatedVisit = currentVisit!.copyWith(
        enviroment: List.from(currentEnvironments),
      );

      // Atualiza no backend
      await updateVisit(updatedVisit);

      // Recarrega os dados
      await refreshVisits();

      success();
      Logger().d('Ambiente removido com sucesso');
    } catch (e) {
      Logger().e('Erro ao remover ambiente: $e');
      setError('Erro ao remover ambiente');
      rethrow;
    }
  }

  Future<void> updateEnvironment(EnviromentObject environment) async {
    try {
      showLoadingAndResetState();
      if (currentVisit?.id == null) {
        throw Exception('Nenhuma visita selecionada');
      }

      Logger().d('Tentando atualizar ambiente. CurrentVisit: ${currentVisit?.id}');
      Logger().d('Ambiente: ${environment.toString()}');

      // Atualiza no backend
      await _service.updateEnvironmentInVisit(currentVisit!.id!, environment);

      // Atualiza na lista local
      final index =
          currentEnvironments.indexWhere((env) => env.id == environment.id);
      if (index != -1) {
        currentEnvironments[index] = environment;
      }

      // Atualiza a visita atual
      final updatedVisit = currentVisit!.copyWith(
        enviroment: List.from(currentEnvironments),
      );

      await updateVisit(updatedVisit);
      await refreshVisits();

      success();
      Logger().d('Ambiente atualizado com sucesso');
    } catch (e) {
      Logger().e('Erro ao atualizar ambiente: $e');
      setError('Erro ao atualizar ambiente');
      rethrow;
    }
  }

  List<TechnicalVisitObject> get technicalVisits => _technicalVisits;

  EnviromentObject? getEnvironment(String environmentId) {
  try {
    return currentEnvironments.firstWhere(
      (env) => env.id == environmentId,
    );
  } catch (e) {
    Logger().d('Ambiente não encontrado: $environmentId');
    return null;
  }
}

}
