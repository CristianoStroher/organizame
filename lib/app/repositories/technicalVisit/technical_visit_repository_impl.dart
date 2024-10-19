import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

class TechnicalVisitRepositoryImpl extends TechnicalVisitRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';

  TechnicalVisitRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(technicalVisit.id)
          .set(technicalVisit.toMap());
    } catch (e) {
      throw Exception('Falha ao criar visita técnica: $e');
    }
  }
}
