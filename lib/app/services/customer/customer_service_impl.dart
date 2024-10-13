import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/repositories/customer/customer_repository.dart';

import './customer_service.dart';

class CustomerServiceImpl extends CustomerService {

  final CustomerRepository _customerRepository;

  CustomerServiceImpl({
    required CustomerRepository customerRepository,
  }) : _customerRepository = customerRepository;

  //função para salvar o cliente
  @override
  Future<void> saveCustomer(String name, String phone, String address) =>
    _customerRepository.saveCustomer(name, phone, address);

  @override
  Future<List<CustomerObject>> findAllCustomers() {
    return _customerRepository.findAllCustomers();
  }
  
  @override
  Future<bool> deleteCustomer(CustomerObject customer) {
    return _customerRepository.deleteCustomer(customer);
  }
  
  @override
  Future<CustomerObject> findCustomerById(String id) {
    return _customerRepository.findCustomerById(id);
  }
  
  @override
  Future<void> updateCustomer(CustomerObject customer) {
    return _customerRepository.updateCustomer(customer);
  }
   
}