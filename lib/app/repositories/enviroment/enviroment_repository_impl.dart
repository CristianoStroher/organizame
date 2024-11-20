import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_object.dart';

import './enviroment_repository.dart';

class EnviromentRepositoryImpl extends EnviromentRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';
  final FirebaseStorage _storage;

  EnviromentRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

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