import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/services/customer/customer_service.dart';

class CustomerController extends DefautChangeNotifer {
  final CustomerService _customerService;
  final Logger _logger = Logger();

  List<CustomerObject> filteredCustomer = [];

  CustomerController({
    required CustomerService customerService,
  })  : _customerService = customerService,
        super() {
    resetState();
    findAllCustomers();
  }

  // Método para salvar o cliente
    Future<void> saveCustomer(String name, String phone, String address) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      if (name.isEmpty) {
        throw Exception('Nome é obrigatório');
      }

      if (phone.isEmpty) {
        throw Exception('Telefone é obrigatório');
      }

      // Validação adicional pode ser adicionada aqui

      await _customerService.saveCustomer(name, phone, address);
      
      _logger.i('Cliente salvo com sucesso: $name');
      
      await findAllCustomers();
      success();
    } catch (e) {
      _logger.e('Erro ao salvar cliente: $e');
      setError('Erro ao salvar cliente: ${e.toString()}');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  // Método para buscar todos os clientes
   Future<void> findAllCustomers() async {
    _logger.i('Iniciando findAllCustomers');
    try {
      showLoadingAndResetState();
      
      // Busca todos os clientes do serviço
      final customers = await _customerService.findAllCustomers();

      if (customers.isNotEmpty) {
        // Ordena os clientes por nome
        customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        filteredCustomer = customers;
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
      List<CustomerObject> customers = snapshot.docs.map((doc) => CustomerObject.fromFirestore(doc)).toList();
      customers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      filteredCustomer = customers;
      notifyListeners();
      return customers;
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
        await findAllCustomers();

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
