import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_imagens.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';


class EnviromentImagesRepositoryImpl extends EnviromentImagesRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';
  final FirebaseStorage _storage;

  EnviromentImagesRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

  @override
    Future<EnviromentImagens> uploadImage(String visitId, String environmentId, File imageFile, String description) async {
    try {
      Logger().d('Iniciando upload de imagem para ambiente $environmentId');

      // Criar nome único para o arquivo
      final fileName = 'env_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'visits/$visitId/environments/$environmentId/$fileName';
      
      // Fazer upload para o Storage
      final storageRef = _storage.ref().child(path);
      await storageRef.putFile(imageFile);
      final fileUrl = await storageRef.getDownloadURL();

      // Criar objeto da imagem
      final imagem = EnviromentImagens(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: fileUrl,
        creationDate: DateTime.now(),
        dateTime: DateTime.now(),
        description: description,
      );

      // Atualizar documento no Firestore
      await _addImageToEnvironment(visitId, environmentId, imagem);

      Logger().d('Imagem enviada com sucesso: ${imagem.id}');
      return imagem;
    } catch (e) {
      Logger().e('Erro no upload da imagem: $e');
      rethrow;
    }
  }

  Future<void> _addImageToEnvironment(String visitId, String environmentId, EnviromentImagens imagem) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final environments = dados['environments'] as List<dynamic>;
      
      final environmentIndex = environments.indexWhere(
        (env) => env['id'].toString() == environmentId
      );

      if (environmentIndex == -1) {
        throw Exception('Ambiente não encontrado');
      }

      // Adicionar imagem ao ambiente
      List<Map<String, dynamic>> imagens = [];
      if (environments[environmentIndex]['imagens'] != null) {
        imagens = List<Map<String, dynamic>>.from(environments[environmentIndex]['imagens']);
      }
      
      imagens.add(imagem.toJson());
      environments[environmentIndex]['imagens'] = imagens;

      // Atualizar documento
      await docRef.update({'environments': environments});
    } catch (e) {
      Logger().e('Erro ao adicionar imagem ao ambiente: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(String visitId, String environmentId, EnviromentImagens imagem) async {
    try {
      Logger().d('Iniciando exclusão de imagem ${imagem.id}');

      // Deletar do Storage
      if (imagem.filePath.startsWith('http')) {
        final ref = _storage.refFromURL(imagem.filePath);
        await ref.delete();
      }

      // Remover do Firestore
      await _removeImageFromEnvironment(visitId, environmentId, imagem.id);

      Logger().d('Imagem deletada com sucesso');
    } catch (e) {
      Logger().e('Erro ao deletar imagem: $e');
      rethrow;
    }
  }

  Future<void> _removeImageFromEnvironment(String visitId, String environmentId, String imageId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final environments = dados['environments'] as List<dynamic>;
      
      final environmentIndex = environments.indexWhere(
        (env) => env['id'].toString() == environmentId
      );

      if (environmentIndex == -1) {
        throw Exception('Ambiente não encontrado');
      }

      // Remover imagem do ambiente
      if (environments[environmentIndex]['imagens'] != null) {
        List<Map<String, dynamic>> imagens = List<Map<String, dynamic>>.from(
          environments[environmentIndex]['imagens']
        );
        imagens.removeWhere((img) => img['id'] == imageId);
        environments[environmentIndex]['imagens'] = imagens;

        // Atualizar documento
        await docRef.update({'environments': environments});
      }
    } catch (e) {
      Logger().e('Erro ao remover imagem do ambiente: $e');
      rethrow;
    }
  }

  Future<void> updateImageDescription(
    String visitId,
    String environmentId,
    String imageId,
    String newDescription
  ) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final environments = dados['environments'] as List<dynamic>;
      
      final environmentIndex = environments.indexWhere(
        (env) => env['id'].toString() == environmentId
      );

      if (environmentIndex == -1) {
        throw Exception('Ambiente não encontrado');
      }

      // Atualizar descrição da imagem
      if (environments[environmentIndex]['imagens'] != null) {
        List<Map<String, dynamic>> imagens = List<Map<String, dynamic>>.from(
          environments[environmentIndex]['imagens']
        );
        
        final imageIndex = imagens.indexWhere((img) => img['id'] == imageId);
        if (imageIndex != -1) {
          imagens[imageIndex]['description'] = newDescription;
          environments[environmentIndex]['imagens'] = imagens;

          // Atualizar documento
          await docRef.update({'environments': environments});
        }
      }
    } catch (e) {
      Logger().e('Erro ao atualizar descrição da imagem: $e');
      rethrow;
    }
  }



}
