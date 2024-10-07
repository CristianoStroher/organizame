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

  Future<void> findAllCustomers() async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final customers = await _customerService.findAllCustomers();
      if (customers.isNotEmpty) {
        success();
      } else {
        setError('Nenhum cliente encontrado');
      }
    } catch (e) {
      setError('Erro ao buscar clientes');
    }
  }


  
}