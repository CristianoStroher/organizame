import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

class TechnicalVisitRepositoryImpl extends TechnicalVisitRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';

  TechnicalVisitRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createTechnicalVisit(TechnicalVisitObject technicalVisitObject) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(technicalVisitObject.id)
          .set(technicalVisitObject.toMap());
    } catch (e) {
      throw Exception('Falha ao criar visita técnica: $e');
      Logger().e('Falha ao criar visita técnica: $e');
    }
  }
  
  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() {
    try {
      return _firestore.collection(_collection).get().then((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => TechnicalVisitObject.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Falha ao buscar visitas técnicas: $e');
      Logger().e('Falha ao buscar visitas técnicas: $e');
    }
  
  }
  
  
    
  
}
