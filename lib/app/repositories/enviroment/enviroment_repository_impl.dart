import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_object.dart';

import './enviroment_repository.dart';

class EnviromentRepositoryImpl extends EnviromentRepository {
  
  final FirebaseFirestore _firestore;
  final Logger _logger;
  final String _collection = 'enviroments';
  
  EnviromentRepositoryImpl(
    FirebaseFirestore? firestore,
    Logger? logger,
    ) : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  @override
  Future<void> saveEnviroment(EnviromentObject enviroment) async {
    try {

      await _firestore
          .collection(_collection)
          .doc(enviroment.id)
          .set(enviroment.toMap());
    } catch (e) {
      _logger.e('Erro ao salvar ambiente: $e');
      rethrow;
    }
  }
}
