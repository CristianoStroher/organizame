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
  Future<void> saveTechnicalVisit(
      TechnicalVisitObject technicalVisitObject) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(technicalVisitObject.id)
          .set(technicalVisitObject.toMap());
    } catch (e) {
      Logger().e('Falha ao criar visita técnica: $e');
      throw Exception('Falha ao criar visita técnica: $e');
    }
  }

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      final visits = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data != null) {
          return TechnicalVisitObject.fromFirestore(doc);
        } else {
          Logger().w('Documento vazio ou inválido: ${doc.id}');
          throw Exception('Documento inválido: ${doc.id}');
        }
      }).toList();

      Logger().i('Visitas técnicas carregadas: ${visits.length}');
      return visits;
    } catch (e) {
      Logger().e('Falha ao buscar visitas técnicas: $e');
      throw Exception('Falha ao buscar visitas técnicas: $e');
    }
  }
}
