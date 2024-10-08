import 'package:organizame/app/models/customer_object.dart';

abstract class CustomerRepository {
  
  Future<void> saveCustomer(String name, String phone, String address);
  Future <List<CustomerObject>> findAllCustomers();
  Future<bool> deleteCustomer(CustomerObject customer);
  
}