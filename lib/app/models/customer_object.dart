import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class CustomerObject {
  final String? id;
  final String name;
  final String? phone;
  final String? address;

  CustomerObject({this.id, required this.name, this.phone, this.address});

  // Construtor de fábrica para converter um mapa em um objeto
  factory CustomerObject.fromMap(Map<String, dynamic> map, {String? id}) {
    try {
      return CustomerObject(
        id: id ?? map['id'] as String?, // Usando o ID do Firestore, se disponível
        name: map['name'] as String,
        phone: map['phone'] as String?,
        address: map['address'] as String?,
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para CustomerObject: $e');
      rethrow;
    }
  }

  // Construtor de fábrica para converter um DocumentSnapshot do Firestore em um CustomerObject
  factory CustomerObject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Pegando os dados do snapshot
    return CustomerObject.fromMap(data, id: doc.id); // Usando o fromMap e passando o ID do documento
  }

  // Converte o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}
