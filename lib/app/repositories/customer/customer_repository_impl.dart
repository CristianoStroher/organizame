import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';

import './customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository {
  
  final FirebaseFirestore _firestore; // adiconado conexao com o firestore

  // construtor
  CustomerRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<void> saveCustomer(String name, String phone, String address) async {
    try {
      await _firestore.collection('customers').add({
        'name': name.toUpperCase(),
        'phone': phone,
        'address': address.toUpperCase(),
      });
    } catch (e, s) {
      Logger().e('Erro ao salvar o cliente: $e');
      Logger().e('Stacktrace: $s');
      rethrow;
    }
  }

  @override
  Future<List<CustomerObject>> findAllCustomers() async {
    try {
      final querySnapshot = await _firestore.collection('customers').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();

        return CustomerObject(
          id: doc.id,
          name: data['name'] ?? '',
          phone: data['phone'],
          address: data['address'],
        );
      }).toList();
    } catch (e, s) {
      Logger().e('Erro ao buscar clientes: $e');
      Logger().e('Stacktrace: $s');
      rethrow;
    }
  }

  @override
  Future<bool> deleteCustomer(CustomerObject customer) {
    try {
      _firestore.collection('customers').doc(customer.id).delete();
      return Future.value(true);
    } catch (e, s) {
      Logger().e('Erro ao deletar o cliente: $e');
      Logger().e('Stacktrace: $s');
      return Future.value(false);
    }
  }

  @override
  Future<CustomerObject> findCustomerById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('customers').doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return CustomerObject(
          id: docSnapshot.id,
          name: data?['name'] ?? '',
          phone: data?['phone'] ?? '',
          address: data?['address'] ?? '',
        );
      } else {
        throw Exception('Cliente não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }

  @override
  Future<void> updateCustomer(CustomerObject customer) async {
    try {
      await _firestore.collection('customers').doc(customer.id).update({
        'name': customer.name,
        'phone': customer.phone,
        'address': customer.address,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar cliente: $e');
    }
  }
}
