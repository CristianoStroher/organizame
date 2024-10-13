import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/services/customer/customer_service.dart';

class CustomerController extends DefautChangeNotifer {
  final CustomerService _customerService;

  List<CustomerObject> filteredCustomer = [];

  CustomerController({
    required CustomerService customerService,
  })  : _customerService = customerService,
        super() {
    resetState();
  }

  // Método para salvar o cliente
  Future<void> saveCustomer(String name, String phone, String address) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      if (name.isNotEmpty) {
        await _customerService.saveCustomer(
          name,
          phone,
          address,
        );
        await findAllCustomers();
        success();
        notifyListeners();
      } else {
        setError('Nome é obrigatório');
      }
    } catch (e) {
      setError('Erro ao salvar cliente');
    }
  }

  // Método para buscar todos os clientes
  Future<void> findAllCustomers() async {
    showLoadingAndResetState();
    print('Iniciando findAllCustomers');

    try {
      // Busca todos os clientes do serviço
      final customers = await _customerService.findAllCustomers();

      if (customers.isNotEmpty) {
        // Ordena os clientes por nome
        customers.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        filteredCustomer = customers;
        success();
      } else {
        setError('Nenhum cliente encontrado');
      }

      // Notifica os ouvintes que a lista foi atualizada
      print('Notificando listeners após atualização da lista de clientes');
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar clientes: $e');
      setError('Erro ao buscar clientes');
      notifyListeners();
    }
  }

  Future<void> refreshPage() async {
    print('Iniciando refreshPage');
    await findAllCustomers();
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
      return deleted; // Retorna true ou false baseado no sucesso da operação
    } catch (e, s) {
      Logger().e('Erro ao deletar cliente: $e');
      Logger().e('Stacktrace: $s');
      setError('Erro ao deletar cliente');
      return false; // Retorna false em caso de exceção
    } finally {
      hideLoading();
      notifyListeners();
      refreshPage();
    }
  }

  Stream<List<CustomerObject>> getAllCustomersStream() {
    return FirebaseFirestore.instance
        .collection('customers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CustomerObject.fromFirestore(doc);
      }).toList();
    });
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
      // Buscar o cliente pelo ID
      final selectedCustomer = await findCustomerById(object.id!);

      if (selectedCustomer != null) {
        // Atualizar os campos necessários no serviço
        await _customerService.updateCustomer(object);

        // Notificar listeners sobre a mudança
        notifyListeners();
        success();
      } else {
        throw Exception('Cliente não encontrado');
      }
    } catch (e) {
      setError('Erro ao editar cliente: $e');
    }
  }
}
