// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/budgets_object.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/customer/customer_controller.dart';
import 'package:organizame/app/services/budgets/budgets_service.dart';

class BudgetsController extends DefautChangeNotifer {
  final CustomerController _customerController;
  final BudgetsService _service;
  List<BudgetsObject> _filteredBudgets = [];
  List<BudgetsObject> _budgets = [];

  // Getter para orçamentos filtrados
  List<BudgetsObject> get bugets => _budgets;
  List<BudgetsObject> get filteredBugets => _filteredBudgets;
  bool get isStauts => loading; // Verifica se está carregando
  bool get hasBugets => _budgets.isNotEmpty; // Verifica se tem orçamentos
  bool get hasFilteredBudgets => _filteredBudgets.isNotEmpty;

  BudgetsController({
    required CustomerController customerController,
    required BudgetsService service,
  })  : _service = service,
        _customerController = customerController;

  Future<bool> saveBudget(BudgetsObject budget) async {
    try {
      showLoadingAndResetState();
      await _service.saveBudget(budget);
      success();
      await refreshVisits();
      return true;
    } catch (e) {
      setError('Erro ao salvar orçamento');
      return false;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<List<BudgetsObject>> getAllBudgets() {
    showLoadingAndResetState();
    return _service.getAllBudgets();
    hideLoading();
  }

  Future<void> refreshVisits() async {
    try {
      showLoadingAndResetState();
      final newBudgets = await _service.getAllBudgets();

      // Ordena pela data mais recente primeiro
      newBudgets.sort((a, b) {
        final dateTimeA = DateTime(
          a.date.year,
          a.date.month,
          a.date.day,
          a.date.hour,
          a.date.minute,
          a.date.second,
        );
        final dateTimeB = DateTime(
          b.date.year,
          b.date.month,
          b.date.day,
          b.date.hour,
          b.date.minute,
          b.date.second,
        );
        return dateTimeB.compareTo(dateTimeA);
      });

      _budgets = newBudgets;
      // Mantém todos os orçamentos visíveis por padrão
      _filteredBudgets = List.from(newBudgets);
      success();
    } catch (e) {
      setError('Erro ao atualizar lista');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<bool> deleteBudget(BudgetsObject budget) async {
    try {
      showLoadingAndResetState();
      await _service.deleteBudget(budget.id);
      await refreshVisits();
      success();
      return true;
    } catch (e) {
      setError('Erro ao excluir orçamento');
      return false;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  void clearFilters() {
    _filteredBudgets = List.from(_budgets);
    notifyListeners();
  }

  Future<List<CustomerObject>> getCustomers() async {
    try {
      // Usando o método do CustomerController
      await _customerController.findAllCustomers();
      // Retornando a lista atualizada através do customersNotifier
      return _customerController.customersNotifier.value;
    } catch (e) {
      throw Exception('Erro ao buscar clientes: $e');
    }
  }

  Future<bool> updateBudget(BudgetsObject budget) async {
    try {
      showLoadingAndResetState();
      await _service.updateBudget(budget);
      success();
      await refreshVisits();
      return true;
    } catch (e) {
      setError('Erro ao atualizar orçamento');
      return false;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> filterBudgets(
      {String? customerName,
      DateTime? startDate,
      DateTime? endDate,
      bool? showCompleted // Tornar opcional
      }) async {
    try {
      showLoadingAndResetState();

      _filteredBudgets = _budgets.where((budget) {
        // Só aplica o filtro de status se showCompleted for fornecido
        if (showCompleted != null && !showCompleted && budget.status) {
          return false;
        }

        // Aplica os outros filtros
        if (customerName != null && customerName.length >= 3) {
          if (!budget.customer.name
              .toLowerCase()
              .contains(customerName.toLowerCase())) {
            return false;
          }
        }

        if (startDate != null || endDate != null) {
          final budgetDate = DateTime(
            budget.date.year,
            budget.date.month,
            budget.date.day,
          );

          if (startDate != null && budgetDate.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && budgetDate.isAfter(endDate)) {
            return false;
          }
        }

        return true;
      }).toList();

      _filteredBudgets.sort((a, b) => b.date.compareTo(a.date));
      success();
    } catch (e) {
      setError('Erro ao filtrar orçamentos');
      _filteredBudgets = List.from(_budgets);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
