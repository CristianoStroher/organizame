import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';
import 'package:mockito/annotations.dart';

class TechnicalVisitRepositoryImpl extends TechnicalVisitRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';

  TechnicalVisitRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveTechnicalVisit(
    DateTime date,
    DateTime time,
    CustomerObject customer,
  ) async {
    try {
      await _firestore.collection(_collection).add({
        'date': date,
        'time': time,
        'customer': customer.toMap(),
      });
    } catch (e) {
      Logger().e('Erro ao salvar a visita técnica: $e');
      throw Exception('Erro ao salvar a visita técnica: $e');
      rethrow;
    }
  }

  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();

      final List<TechnicalVisitObject> visitas = [];

      for (var doc in querySnapshot.docs) {
        try {
          final dados = doc.data();

          // Verifica e converte o cliente
          final clienteMap = dados['customer'] as Map<String, dynamic>?;

          if (clienteMap == null) {
            continue; // Pula este documento
          }

          final customer = CustomerObject.fromMap(clienteMap);

          // Verifica e converte data e hora
          final dataTimestamp = dados['date'];
          final horaTimestamp = dados['time'];

          if (dataTimestamp == null) {
            continue;
          }

          final DateTime date = dataTimestamp is DateTime
              ? dataTimestamp
              : (dataTimestamp as Timestamp).toDate();

          final DateTime time = horaTimestamp is DateTime
              ? horaTimestamp
              : (horaTimestamp as Timestamp).toDate();

          final visita = TechnicalVisitObject(
            id: doc.id,
            date: date,
            time: time,
            customer: customer,
          );

          visitas.add(visita);
        } catch (e, stackTrace) {
          continue;
        }
      }

      return visitas;
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      _firestore.collection(_collection).doc(technicalVisit.id).delete();
      return Future.value(true);
    } catch (e) {
      Logger().e('Erro ao deletar a visita técnica: $e');
      throw Exception('Erro ao deletar a visita técnica: $e');
      return Future.value(false);
    }
  }

  @override
  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit) async {

    try {
      await _firestore.collection(_collection).doc(technicalVisit.id).update({
        'date': technicalVisit.date,
        'time': technicalVisit.time,
        'customer': technicalVisit.customer.toMap(),
      });
      Logger().i('Repositorio - Visita técnica atualizada com sucesso id: ${technicalVisit.id}');
    } catch (e) {
      Logger().e('Repositorio - Erro ao atualizar a visita técnica: $e');
      throw Exception('Repositorio - Erro ao atualizar a visita técnica: $e');
    }
  }

  @override
  Future<TechnicalVisitObject> findTechnicalVisitById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data();
        return TechnicalVisitObject(
          id: docSnapshot.id,
          date: data?['date'] ?? '',
          time: data?['time'] ?? '',
          customer: data?['customer'] ?? '',
        );
      } else {
        throw Exception('Visita técnica não encontrada & id: $id');
      }
    } on Exception catch (e) {
      Logger().e('Erro ao buscar visita técnica: $e');
      throw Exception('Erro ao buscar visita técnica: $e');
    }
  }

}
