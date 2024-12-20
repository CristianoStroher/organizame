import 'package:organizame/app/models/customer_object.dart';

abstract class CustomerService {
    
    Future<void> saveCustomer(CustomerObject customer);
    Future <List<CustomerObject>> findAllCustomers();
    Future<bool> deleteCustomer(CustomerObject customer);
    Future<void> updateCustomer(CustomerObject customer);
    Future<CustomerObject> findCustomerById(String id);

}