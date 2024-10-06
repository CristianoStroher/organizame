import 'package:logger/logger.dart';

class CustomerObject {
  final int? id;
  final String name;
  final String? phone;
  final String? address;

  CustomerObject({this.id, required this.name, this.phone, this.address});

  // construtor de fábrica para converter um mapa em um objeto
  factory CustomerObject.fromMap(Map<String, dynamic> map) {
    try {
      return CustomerObject(
        id: map['id'] as int?,
        name: map['name'] as String,
        phone: map['phone'] as String?,
        address: map['address'] as String?,
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para CustomerObject: $e');
      rethrow;
    }
  }

  // converte o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}
