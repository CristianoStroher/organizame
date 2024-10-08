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
        success();
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
    notifyListeners();
    Logger().i('Buscando clientes');//!   

    try {
      // Busca todos os clientes do serviço
      final customers = await _customerService.findAllCustomers();

      if (customers.isNotEmpty) {
        // Atualiza a lista de clientes filtrados
        filteredCustomer = customers;
        success();
      } else {
        setError('Nenhum cliente encontrado');
      }

      // Notifica os ouvintes que a lista foi atualizada
      notifyListeners();
    } catch (e) {
      setError('Erro ao buscar clientes');
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

Future<void> refreshPage() async {
    await findAllCustomers();
    notifyListeners();
  }



}
