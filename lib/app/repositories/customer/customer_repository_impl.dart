import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import './customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository {
       
    final FirebaseFirestore _firestore; // adiconado conexao com o firestore

    // construtor
    CustomerRepositoryImpl ({
      required FirebaseFirestore firestore,
    }) : _firestore = firestore;
    
      @override
      Future<void> saveCustomer(String name, String phone, String address) async {
        try {
          await _firestore.collection('customers').add({
            'name': name,            
            'phone': phone,
            'address': address,
          });
        } catch (e, s) {
          Logger().e('Erro ao salvar o cliente: $e');
          Logger().e('Stacktrace: $s');
          rethrow;
        }  

      }



    
    
    
  }

