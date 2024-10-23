import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/services/customer/customer_service.dart';

class CustomerController extends DefautChangeNotifer {
  final CustomerService _customerService;
  final Logger _logger = Logger();
  final ValueNotifier<List<CustomerObject>> customersNotifier = ValueNotifier<List<CustomerObject>>([]);

  CustomerController({
    required CustomerService customerService,
  })  : _customerService = customerService,
        super() {
    resetState();
    refreshCustomers();
  }

  Future<void> saveCustomer(String name, String? phone, String? address) async {
    
    try {
      showLoadingAndResetState();
      notifyListeners();

      if (name.isEmpty) {
        throw Exception('Nome é obrigatório');
      }

      final newCustomer = CustomerObject(
        name: name.toUpperCase(),
        phone: phone?.isNotEmpty == true ? phone : null,
        address: address?.isNotEmpty == true ? address?.toUpperCase() : null,
      );

      await _customerService.saveCustomer(newCustomer);
      _logger.i('Cliente salvo com sucesso: $name');

      await refreshCustomers();
      success();
    } catch (e) {
      _logger.e('Erro ao salvar cliente: $e');
      setError('Erro ao salvar cliente: ${e.toString()}');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> refreshCustomers() async {
    _logger.i('Atualizando lista de clientes');
    try {
      showLoadingAndResetState();
      final customers = await _customerService.findAllCustomers();
      customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      customersNotifier.value = customers;
      success();
    } catch (e) {
      _logger.e('Erro ao atualizar lista de clientes: $e');
      setError('Erro ao atualizar lista de clientes: ${e.toString()}');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Stream<List<CustomerObject>> getAllCustomersStream() {
    return FirebaseFirestore.instance
        .collection('customers')
        .snapshots()
        .map((snapshot) {
      List<CustomerObject> customers = snapshot.docs
          .map((doc) => CustomerObject.fromFirestore(doc))
          .toList();
      customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      customersNotifier.value = customers;
      return customers;
    });
  }

  Future<void> findAllCustomers() async {

    try {
      showLoadingAndResetState();
      
      final customers = await _customerService.findAllCustomers();

      if (customers.isNotEmpty) {
        customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        customersNotifier.value = customers;
        success();
      } else {
        setError('Nenhum cliente encontrado');
      }
    } catch (e) {
      _logger.e('Erro ao buscar clientes: $e');
      setError('Erro ao buscar clientes: ${e.toString()}');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<bool> deleteCustomer(CustomerObject customer) async {
    try {
      showLoadingAndResetState();

      final deleted = await _customerService.deleteCustomer(customer);

      if (deleted) {
        success();
      } else {
        setError('Erro ao deletar cliente');
      }
      return deleted;
    } catch (e, s) {
      _logger.e('Erro ao deletar cliente: $e');
      _logger.e('Stacktrace: $s');
      setError('Erro ao deletar cliente');
      return false;
    } finally {
      hideLoading();
      notifyListeners();
      refreshCustomers();
    }
  }

  Future<CustomerObject?> findCustomerById(String id) async {
    try {
      final customer = await _customerService.findCustomerById(id);

      if (customer != null) {
        return customer;
      } else {
        setError('Cliente não encontrado');
        return null;
      }
    } catch (e) {
      setError('Erro ao buscar cliente');
      return null;
    }
  }

  Future<void> updateCustomer(CustomerObject object) async {
    try {
      if (object.id == null || object.id!.isEmpty) {
        throw Exception('ID do cliente é nulo ou inválido');
      }
      showLoadingAndResetState();

      final selectedCustomer = await findCustomerById(object.id!);

      if (selectedCustomer != null) {
        await _customerService.updateCustomer(object);
        await refreshCustomers();
        success();
      } else {
        throw Exception('Cliente não encontrado');
      }
    } catch (e) {
      setError('Erro ao editar cliente: $e');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}