abstract class CustomerRepository {
  
  Future<void> saveCustomer(String name, String phone, String address);

}