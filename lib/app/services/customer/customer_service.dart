import 'package:organizame/app/models/customer_object.dart';

abstract class CustomerService {
    
    Future<void> saveCustomer(String name, String phone, String address);
    Future <List<CustomerObject>> findAllCustomers();

}