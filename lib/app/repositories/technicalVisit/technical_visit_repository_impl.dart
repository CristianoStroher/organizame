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

  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() async {
    try {
      print('Repositório - Buscando visitas no Firestore');
      final querySnapshot = await _firestore.collection(_collection).get();

      print(
          'Repositório - Documentos encontrados: ${querySnapshot.docs.length}');

      final List<TechnicalVisitObject> visitas = [];

      for (var doc in querySnapshot.docs) {
        try {
          final dados = doc.data();
          print('Processando documento ${doc.id}:');
          print('Dados brutos: $dados');

          // Verifica e converte o cliente
          final clienteMap = dados['cliente'] as Map<String, dynamic>?;
          print('Cliente dados: $clienteMap');

          if (clienteMap == null) {
            print('AVISO: Cliente não encontrado para documento ${doc.id}');
            continue; // Pula este documento
          }

          final cliente = CustomerObject.fromMap(clienteMap);

          // Verifica e converte data e hora
          final dataTimestamp = dados['data'];
          final horaTimestamp = dados['hora'];

          print('Data timestamp: $dataTimestamp');
          print('Hora timestamp: $horaTimestamp');

          if (dataTimestamp == null) {
            print('ERRO: Data não encontrada para documento ${doc.id}');
            continue;
          }

          final DateTime data = dataTimestamp is DateTime
              ? dataTimestamp
              : (dataTimestamp as Timestamp).toDate();

          final DateTime hora = horaTimestamp is DateTime
              ? horaTimestamp
              : (horaTimestamp as Timestamp).toDate();

          final visita = TechnicalVisitObject(
            id: doc.id,
            data: data,
            hora: hora,
            cliente: cliente,
          );

          print('Visita criada com sucesso: $visita');
          visitas.add(visita);
        } catch (e, stackTrace) {
          print('Erro ao processar documento ${doc.id}: $e');
          print('Stack trace: $stackTrace');
          // Continue processando outros documentos
          continue;
        }
      }

      print('Total de visitas processadas com sucesso: ${visitas.length}');
      return visitas;
    } catch (e, stackTrace) {
      print('Erro ao buscar visitas técnicas: $e');
      print('Stack trace: $stackTrace');
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
}
