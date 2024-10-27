import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/services/technicalVisit/technical_visit_service.dart';

class TechnicalController extends DefautChangeNotifer {
  final TechnicalVisitService _service;
  List<TechnicalVisitObject> _technicalVisits = [];
  List<TechnicalVisitObject> _filteredVisits = [];

  // Getter para visitas filtradas
  List<TechnicalVisitObject> get filteredTechnicalVisits => _filteredVisits;
  List<TechnicalVisitObject> get allTechnicalVisits => _technicalVisits;
  bool get isLoading => loading;
  bool get hasVisits => _technicalVisits.isNotEmpty;
  bool get hasFilteredVisits => _filteredVisits.isNotEmpty;

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

  // Método para filtrar visitas por cliente
  void filterByCustomer(String customerName) {
    try {
      showLoadingAndResetState();

      if (customerName.isEmpty) {
        // Se não houver filtro, recarrega todas as visitas
        loadTechnicalVisits();
        return;
      }

      // Filtrar a lista baseado no nome do cliente
      _technicalVisits = _technicalVisits
          .where((visit) => visit.customer.name
              .toLowerCase()
              .contains(customerName.toLowerCase()))
          .toList();

      success();
    } catch (e) {
      setError('Erro ao filtrar visitas técnicas');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  // Método para atualizar a lista após criar ou editar uma visita
  Future<void> refreshVisits() async {
    await loadTechnicalVisits();
  }

  void clearFilters() {
    _filteredVisits = List.from(_technicalVisits);
    notifyListeners();
  }
}
