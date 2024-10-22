import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

class TechnicalVisitRepositoryImpl extends TechnicalVisitRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';

  TechnicalVisitRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveTechnicalVisit(
    DateTime data,
    DateTime hora,
    CustomerObject cliente,
  ) async {
    try {
      await _firestore.collection(_collection).add({
        'data': data,
        'hora': hora,
        'cliente': cliente.toMap(),
      });
    } catch (e) {
      Logger().e('Erro ao salvar a visita técnica: $e');
      throw Exception('Erro ao salvar a visita técnica: $e');
      rethrow;
    }
  }

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() async {
    final querySnapshot = await _firestore.collection(_collection).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TechnicalVisitObject(
        id: doc.id,
        data: data['data'].toDate(),
        hora: data['hora'].toDate(),
        cliente: CustomerObject.fromMap(data['cliente']),
      );
    }).toList();
  }
  
}
