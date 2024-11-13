import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';

class TechnicalController extends DefautChangeNotifer {
  final TechnicalVisitService _service;
  List<TechnicalVisitObject> _technicalVisits = [];
  List<TechnicalVisitObject> _filteredVisits = [];
  TechnicalVisitObject? _currentVisit;

  // Getter para visitas filtradas
  List<TechnicalVisitObject> get filteredTechnicalVisits => _filteredVisits;
  List<TechnicalVisitObject> get allTechnicalVisits => _technicalVisits;
  bool get isLoading => loading;
  bool get hasVisits => _technicalVisits.isNotEmpty;
  bool get hasFilteredVisits => _filteredVisits.isNotEmpty;
  TechnicalVisitObject? get currentVisit => _currentVisit;

  set currentVisit(TechnicalVisitObject? visit) {
    _currentVisit = visit;
    notifyListeners();
  }

  TechnicalController({
    required TechnicalVisitService technicalVisitService,
  }) : _service = technicalVisitService {
    loadTechnicalVisits(); // Carrega as visitas quando o controller é criado
  }

  Future<void> loadTechnicalVisits() async {
    try {
      print('Controller - Iniciando carregamento de visitas técnicas');
      showLoadingAndResetState();

      // Buscar visitas do serviço
      final visits = await _service.getAllTechnicalVisits();
      print('Controller - Visitas carregadas: ${visits.length}');
      // Ordenar por data mais recente
      visits.sort((a, b) {
        final dateTimeA = DateTime(
          a.date.year,
          a.date.month,
          a.date.day,
          a.time.hour,
          a.time.minute,
        );

        final dateTimeB = DateTime(
          b.date.year,
          b.date.month,
          b.date.day,
          b.time.hour,
          b.time.minute,
        );

        return dateTimeB.compareTo(dateTimeA); // Mais recentes primeiro
      });

      _technicalVisits = visits;
      _filteredVisits = visits;

      if (_technicalVisits.isNotEmpty) {
        print(
            'Controller - Primeira visita: ${_technicalVisits.first.toString()}');
      }

      success();
    } catch (e, stackTrace) {
      print('Controller - Erro ao carregar visitas: $e'); // Log para debug
      print('Controller - Stack trace: $stackTrace'); // Log para debug
      setError('Controller - Erro ao carregar visitas técnicas');
      _technicalVisits = [];
      _filteredVisits = [];
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> deleteTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      showLoadingAndResetState();
      await _service.deleteTechnicalVisit(technicalVisit);

      // Remover a visita da lista local
      _technicalVisits.removeWhere((visit) => visit.id == technicalVisit.id);

      success();
    } catch (e) {
      setError('Erro ao deletar visita técnica: $e');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  //

  Future<void> filterVisits({
    String? customerName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('Controller - Iniciando filtro combinado');
      print('Nome: $customerName, Início: $startDate, Fim: $endDate');
      showLoadingAndResetState();

      if (customerName == null && startDate == null && endDate == null) {
        _filteredVisits = List.from(_technicalVisits);
        success();
        notifyListeners();
        return;
      }

      _filteredVisits = _technicalVisits.where((visit) {
        bool matchesName = true;
        bool matchesDate = true;

        // Filtro por nome
        if (customerName != null && customerName.length >= 3) {
          matchesName = visit.customer.name
              .toLowerCase()
              .contains(customerName.toLowerCase());
        }

        // Filtro por período
        if (startDate != null || endDate != null) {
          final visitDate = DateTime(
            visit.date.year,
            visit.date.month,
            visit.date.day,
          );

          if (startDate != null && endDate != null) {
            matchesDate = visitDate.isAtSameMomentAs(startDate) ||
                visitDate.isAtSameMomentAs(endDate) ||
                (visitDate.isAfter(startDate) && visitDate.isBefore(endDate));
          } else if (startDate != null) {
            matchesDate = visitDate.isAtSameMomentAs(startDate) ||
                visitDate.isAfter(startDate);
          } else if (endDate != null) {
            matchesDate = visitDate.isAtSameMomentAs(endDate) ||
                visitDate.isBefore(endDate);
          }
        }

        return matchesName && matchesDate;
      }).toList();

      // Ordenar por data/hora
      _filteredVisits.sort((a, b) {
        final dateTimeA = DateTime(
          a.date.year,
          a.date.month,
          a.date.day,
          a.time.hour,
          a.time.minute,
        );

        final dateTimeB = DateTime(
          b.date.year,
          b.date.month,
          b.date.day,
          b.time.hour,
          b.time.minute,
        );

        return dateTimeB.compareTo(dateTimeA);
      });

      print(
          'Controller - Encontradas ${_filteredVisits.length} visitas após filtro');
      success();
    } catch (e) {
      print('Controller - Erro ao filtrar: $e');
      setError('Erro ao filtrar visitas técnicas');
      _filteredVisits = List.from(_technicalVisits);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  // Método para atualizar a lista após criar ou editar uma visita
  Future<void> refreshVisits() async {
    try {
      showLoadingAndResetState();
      Logger().i('Atualizando lista de visitas');

      final newVisits = await _service.getAllTechnicalVisits();
      _technicalVisits = newVisits;

      Logger().d('Lista atualizada: ${_technicalVisits.length} visitas');
      success();
    } catch (e) {
      Logger().e('Erro ao atualizar visitas: $e');
      setError('Erro ao atualizar lista');
    } finally {
      hideLoading();
      notifyListeners(); // Garante notificação aos listeners
    }
  }

  void clearFilters() {
    _filteredVisits = List.from(_technicalVisits);
    notifyListeners();
  }

  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      Logger().i('Controller - Iniciando atualização da visita técnica');
      showLoadingAndResetState();

      await _service.updateTechnicalVisit(technicalVisit);

      // Atualiza a lista principal
      final index =
          _technicalVisits.indexWhere((v) => v.id == technicalVisit.id);
      if (index != -1) {
        _technicalVisits[index] = technicalVisit;
      }

      // Atualiza a lista filtrada se a visita estiver nela
      final filteredIndex =
          _filteredVisits.indexWhere((v) => v.id == technicalVisit.id);
      if (filteredIndex != -1) {
        _filteredVisits[filteredIndex] = technicalVisit;
      }

      // Reordena as listas após a atualização
      _reorderLists();

      Logger().i('Controller - Visita técnica atualizada com sucesso');
      success();
    } catch (e, stackTrace) {
      Logger().e('Controller - Erro ao atualizar visita: $e');
      Logger().e('Controller - Stack trace: $stackTrace');
      setError('Erro ao atualizar visita técnica');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

// Método auxiliar para reordenar as listas mantendo a consistência
  void _reorderLists() {
    final sortVisits = (List<TechnicalVisitObject> visits) {
      visits.sort((a, b) {
        final dateTimeA = DateTime(
          a.date.year,
          a.date.month,
          a.date.day,
          a.time.hour,
          a.time.minute,
        );

        final dateTimeB = DateTime(
          b.date.year,
          b.date.month,
          b.date.day,
          b.time.hour,
          b.time.minute,
        );

        return dateTimeB
            .compareTo(dateTimeA); // Mantém a ordenação mais recente primeiro
      });
    };

    sortVisits(_technicalVisits);
    sortVisits(_filteredVisits);
  }
}
