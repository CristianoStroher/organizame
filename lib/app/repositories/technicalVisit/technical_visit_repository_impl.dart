import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';
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
        'date': Timestamp.fromDate(date),
        'time': Timestamp.fromDate(time),
        'customer': customer.toMap(),
        'environments': [], // Inicializa com array vazio
      });
    } catch (e) {
      Logger().e('Erro ao salvar a visita técnica: $e');
      throw Exception('Erro ao salvar a visita técnica: $e');
    }
  }

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() async {
    try {
      Logger().d('Iniciando busca de visitas técnicas');
      final querySnapshot = await _firestore.collection(_collection).get();
      final List<TechnicalVisitObject> visitas = [];

      for (var doc in querySnapshot.docs) {
        try {
          final dados = doc.data();
          Logger().d('Dados do documento ${doc.id}:');
          Logger().d('Dados completos: $dados');

          final clienteMap = dados['customer'] as Map<String, dynamic>?;
          final dataTimestamp = dados['date'] as Timestamp?;
          final horaTimestamp = dados['time'] as Timestamp?;

          // Tenta carregar ambientes de qualquer um dos campos
          final ambientesData =
              dados['environments'] ?? dados['enviroment'] ?? [];

          Logger()
              .d('Ambientes encontrados para visita ${doc.id}: $ambientesData');

          // Converter ambientes
          List<EnviromentObject> ambientes = [];
          if (ambientesData is List) {
            for (var amb in ambientesData) {
              try {
                Logger().d('Processando ambiente: $amb');
                if (amb is Map<String, dynamic>) {
                  final ambiente = EnviromentObject.fromMap(amb);
                  ambientes.add(ambiente);
                  Logger().d('Ambiente processado com sucesso: ${ambiente.id}');
                }
              } catch (e) {
                Logger().e('Erro ao converter ambiente: $e', error: e);
              }
            }
          }

          if (clienteMap != null &&
              dataTimestamp != null &&
              horaTimestamp != null) {
            final visita = TechnicalVisitObject(
              id: doc.id,
              date: dataTimestamp.toDate(),
              time: horaTimestamp.toDate(),
              customer: CustomerObject.fromMap(clienteMap),
              enviroment: ambientes,
            );

            Logger().d(
                'Visita ${doc.id} carregada com ${ambientes.length} ambientes');
            visitas.add(visita);
          }
        } catch (e) {
          Logger().e('Erro processando documento ${doc.id}: $e');
          continue;
        }
      }

      return visitas;
    } catch (e) {
      Logger().e('Erro ao buscar visitas: $e');
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

  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      Logger().d('Repositório - Iniciando atualização da visita: ${technicalVisit.id}');

      final Map<String, dynamic> updateData = {
        'date': Timestamp.fromDate(technicalVisit.date),
        'time': Timestamp.fromDate(technicalVisit.time),
        'customer': technicalVisit.customer.toMap(),
        'environments': technicalVisit.enviroment?.map((e) => e.toMap()).toList(),
      };

      await _firestore
          .collection(_collection)
          .doc(technicalVisit.id)
          .update(updateData);

      Logger().i('Repositório - Visita técnica atualizada com sucesso id: ${technicalVisit.id}');
    } catch (e, stackTrace) {
      Logger().e('Repositório - Erro ao atualizar a visita técnica: $e');
      Logger().e('Stack trace: $stackTrace');
      throw Exception('Repositório - Erro ao atualizar a visita técnica: $e');
    }
  }

  @override
  Future<TechnicalVisitObject> findTechnicalVisitById(String id) async {
    try {
      Logger().d('Buscando visita técnica por ID: $id');
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        Logger().d('Dados da visita encontrada: $data');

        // Tenta carregar ambientes de qualquer um dos campos
        final ambientesData = data['environments'] ?? data['enviroment'] ?? [];

        List<EnviromentObject> ambientes = [];
        if (ambientesData is List) {
          for (var amb in ambientesData) {
            try {
              if (amb is Map<String, dynamic>) {
                final ambiente = EnviromentObject.fromMap(amb);
                ambientes.add(ambiente);
                Logger().d('Ambiente carregado: ${ambiente.id}');
              }
            } catch (e) {
              Logger().e('Erro ao converter ambiente: $e');
            }
          }
        }

        return TechnicalVisitObject(
          id: docSnapshot.id,
          date: (data['date'] as Timestamp).toDate(),
          time: (data['time'] as Timestamp).toDate(),
          customer: CustomerObject.fromMap(data['customer']),
          enviroment:
              ambientes, // Certifique-se que está passando a lista de ambientes
        );
      } else {
        throw Exception('Visita técnica não encontrada com id: $id');
      }
    } catch (e) {
      Logger().e('Erro ao buscar visita técnica: $e');
      throw Exception('Erro ao buscar visita técnica: $e');
    }
  }

  @override
  Future<void> addEnvironmentToVisit(
      String visitId, EnviromentObject environment) async {
    try {
      Logger().d('Iniciando adição de ambiente à visita $visitId');
      Logger().d('Ambiente a ser adicionado: ${environment.toMap()}');

      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      Logger().d('Dados atuais da visita: $dados');

      // Tenta carregar ambientes de qualquer um dos campos
      final List<dynamic> ambientesAtuais =
          dados['environments'] ?? dados['enviroment'] ?? [];

      Logger().d('Ambientes atuais: $ambientesAtuais');

      // Adiciona o novo ambiente
      final List<Map<String, dynamic>> ambientesAtualizados = [
        ...ambientesAtuais.map((e) => e as Map<String, dynamic>),
        environment.toMap()
      ];

      // Atualiza usando o novo nome do campo
      await docRef.update({'environments': ambientesAtualizados});

      Logger().d('Ambiente adicionado com sucesso');
    } catch (e) {
      Logger().e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeEnvironmentFromVisit(String visitId, String environmentId) async {
    try {
      Logger().d('Repository - Iniciando remoção do ambiente $environmentId da visita $visitId');

      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      Logger().d('Dados atuais da visita: $dados');

      // Pega a lista atual de ambientes
      final List<dynamic> ambientesAtuais =
          dados['environments'] ?? dados['enviroment'] ?? [];

      Logger().d('Ambientes antes da remoção: ${ambientesAtuais.length}');

      // Remove o ambiente com o ID especificado
      final ambientesAtualizados = ambientesAtuais
          .where((ambiente) =>
              ambiente['id'].toString() != environmentId.toString())
          .toList();

      Logger().d('Ambientes após remoção: ${ambientesAtualizados.length}');

      // Atualiza o documento com a nova lista de ambientes
      await docRef.update({'environments': ambientesAtualizados});

      Logger().d('Repository - Ambiente removido com sucesso');
    } catch (e) {
      Logger().e('Repository - Erro ao remover ambiente: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateEnvironmentInVisit(String visitId, EnviromentObject environment) async {
    try {
      Logger().d('Iniciando atualização de ambiente na visita $visitId');
      Logger().d('Ambiente a ser atualizado: ${environment.toMap()}');

      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final List<dynamic> ambientesAtuais = dados['environments'] ?? dados['enviroment'] ?? [];
      
      // Encontra o índice do ambiente a ser atualizado
      final index = ambientesAtuais.indexWhere(
        (amb) => amb['id'].toString() == environment.id.toString()
      );

      if (index == -1) {
        throw Exception('Ambiente não encontrado na visita');
      }

      // Atualiza o ambiente mantendo a mesma posição na lista
      final List<Map<String, dynamic>> ambientesAtualizados = List.from(ambientesAtuais);
      ambientesAtualizados[index] = environment.toMap();

      // Atualiza no Firestore
      await docRef.update({'environments': ambientesAtualizados});

      Logger().d('Ambiente atualizado com sucesso');
    } catch (e) {
      Logger().e('Erro ao atualizar ambiente: $e');
      rethrow;
    }
  }


}
