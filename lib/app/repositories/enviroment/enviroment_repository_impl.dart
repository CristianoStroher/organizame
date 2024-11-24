import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';

class EnviromentRepositoryImpl extends EnviromentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String _collection = 'technical_visits';
  final String _bucket = 'organizame-6649a.firebasestorage.app';

  EnviromentRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = FirebaseStorage.instanceFor(
          bucket: 'organizame-6649a.firebasestorage.app'
        );

  Future<String?> _uploadImageToStorage({
    required String visitId,
    required String environmentId,
    required File imageFile,
    required String description,
  }) async {
    try {
      Logger().d('Iniciando upload para o Storage');
      Logger().d('Usando bucket: $_bucket');

      // Nome único para o arquivo
      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Criar referência para upload usando o bucket correto
      final storageRef = _storage
          .ref()
          .child('visitas')
          .child(visitId)
          .child('ambientes')
          .child(environmentId)
          .child('imagens')
          .child(fileName);

      Logger().d('Tentando upload para path: ${storageRef.fullPath}');

      // Upload com metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'description': description,
          'originalName': imageFile.path.split('/').last,
          'environmentId': environmentId,
          'visitId': visitId,
        }
      );

      // Fazer upload
      final uploadTask = await storageRef.putFile(imageFile, metadata);
      Logger().d('Status do upload: ${uploadTask.state}');

      if (uploadTask.state == TaskState.success) {
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        Logger().d('Upload concluído. URL: $downloadUrl');
        return downloadUrl;
      } else {
        Logger().e('Upload falhou: ${uploadTask.state}');
        return null;
      }

    } catch (e) {
      Logger().e('Erro no upload: $e');
      if (e is FirebaseException) {
        Logger().e('Firebase error code: ${e.code}');
        Logger().e('Firebase error message: ${e.message}');
      }
      return null;
    }
  }

  Future<void> addEnvironmentToVisit(String visitId, EnviromentObject environment) async {
    try {
      Logger().d('Iniciando adição de ambiente à visita $visitId');
      Logger().d('Número de imagens para processar: ${environment.imagens?.length ?? 0}');
      
      List<ImagensObject> imagensProcessadas = [];
      
      // Processar imagens
      if (environment.imagens != null && environment.imagens!.isNotEmpty) {
        for (var imagem in environment.imagens!) {
          try {
            Logger().d('Processando imagem: ${imagem.id}');
            
            final downloadUrl = await _uploadImageToStorage(
              visitId: visitId,
              environmentId: environment.id,
              imageFile: File(imagem.filePath),
              description: imagem.description ?? '',
            );

            if (downloadUrl != null) {
              final imagemProcessada = ImagensObject(
                id: imagem.id,
                filePath: downloadUrl,
                description: imagem.description,
                creationDate: imagem.creationDate,
                dateTime: imagem.dateTime,
              );
              
              imagensProcessadas.add(imagemProcessada);
              Logger().d('Imagem processada com sucesso: ${imagemProcessada.id}');
            }
          } catch (e) {
            Logger().e('Erro ao processar imagem: $e');
          }
        }
      }

      // Atualizar ambiente com as URLs das imagens
      final environmentAtualizado = environment.copyWith(
        imagens: imagensProcessadas.isNotEmpty ? imagensProcessadas : null,
      );

      // Salvar no Firestore
      await _saveEnvironmentToFirestore(visitId, environmentAtualizado);

      Logger().d('Ambiente salvo com ${imagensProcessadas.length} imagens');
    } catch (e) {
      Logger().e('Erro ao adicionar ambiente: $e');
      rethrow;
    }
  }

  Future<void> _saveEnvironmentToFirestore(String visitId, EnviromentObject environment) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final List<dynamic> ambientesAtuais =
          dados['environments'] ?? dados['enviroment'] ?? [];

      final List<Map<String, dynamic>> ambientesAtualizados = [
        ...ambientesAtuais.map((e) => e as Map<String, dynamic>),
        environment.toMap()
      ];

      await docRef.update({'environments': ambientesAtualizados});
      Logger().d('Ambiente salvo no Firestore');
    } catch (e) {
      Logger().e('Erro ao salvar no Firestore: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeEnvironmentFromVisit(
      String visitId, String environmentId) async {
    try {
      Logger().d(
          'Repository - Iniciando remoção do ambiente $environmentId da visita $visitId');

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

  //?atualização de ambiente
  @override
  Future<void> updateEnvironmentInVisit(String visitId, EnviromentObject environment) async {
    try {
      Logger().d('Iniciando atualização de ambiente na visita $visitId');
      Logger().d('Ambiente a ser atualizado: ${environment.toMap()}');

      // Busca a visita no Firestore
      final docRef = _firestore.collection(_collection).doc(visitId);
      // Armazena os dados da visita
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      // Busca a lista de ambientes da visita
      final dados = docSnap.data()!;
      final List<dynamic> ambientesAtuais =
          dados['environments'] ?? dados['enviroment'] ?? [];

      // Encontra o índice do ambiente a ser atualizado
      final index = ambientesAtuais.indexWhere(
          (amb) => amb['id'].toString() == environment.id.toString());

      if (index == -1) {
        throw Exception('Ambiente não encontrado na visita');
      }

      // Atualiza o ambiente mantendo a mesma posição na lista
      final List<Map<String, dynamic>> ambientesAtualizados =
          List.from(ambientesAtuais);
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
