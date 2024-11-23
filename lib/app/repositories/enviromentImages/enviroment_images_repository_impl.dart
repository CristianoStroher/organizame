import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';

class EnviromentImagesRepositoryImpl extends EnviromentImagesRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'technical_visits';
  final FirebaseStorage _storage;
  final String _bucket = 'organizame-6649a.firebasestorage.app';

  EnviromentImagesRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = FirebaseStorage.instanceFor(
          bucket: 'organizame-6649a.firebasestorage.app'
        );

  @override
  Future<ImagensObject> uploadImage(String visitId, String environmentId,
      File imageFile, String description) async {
    try {
      // 1. Nome único para o arquivo
      final fileName = 'test_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 2. Referência ao storage com o bucket correto
      final storage = FirebaseStorage.instanceFor(
          bucket: 'organizame-6649a.firebasestorage.app');

      Logger().d('Usando bucket: ${storage.bucket}');

      // 3. Criar referência para upload
      final storageRef = storage.ref().child('images/$fileName');
      Logger().d('Tentando upload para path: ${storageRef.fullPath}');

      // 4. Upload com metadata
      final metadata =
          SettableMetadata(contentType: 'image/jpeg', customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
        'originalName': imageFile.path.split('/').last,
      });

      // 5. Fazer upload
      final uploadTask = await storageRef.putFile(imageFile, metadata);
      Logger().d('Upload concluído');

      // 6. Obter URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      Logger().d('URL obtida: $downloadUrl');

      // 7. Criar objeto
      final imagem = ImagensObject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: downloadUrl,
        creationDate: DateTime.now(),
        dateTime: DateTime.now(),
        description: description,
      );

      // 8. Salvar no Firestore
      await _addImageToEnvironment(visitId, environmentId, imagem);
      return imagem;
    } on FirebaseException catch (e) {
      Logger().e('Firebase error code: ${e.code}');
      Logger().e('Firebase error message: ${e.message}');
      Logger().e('Path tentado: ${e.stackTrace}');
      throw Exception('Erro no upload: ${e.message}');
    } catch (e) {
      Logger().e('Erro inesperado: $e');
      throw Exception('Erro no upload: $e');
    }
  }

  Future<void> _addImageToEnvironment(
      String visitId, String environmentId, ImagensObject imagem) async {
    try {
      Logger().d('Adicionando imagem ao ambiente...');
      Logger().d('Visit ID: $visitId');
      Logger().d('Environment ID: $environmentId');
      Logger().d('Imagem ID: ${imagem.id}');

      final docRef = _firestore.collection('technical_visits').doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        Logger().e('Documento não encontrado: $visitId');
        throw Exception('Visita não encontrada');
      }

      // Log dos dados atuais
      final data = docSnap.data()!;
      Logger().d('Documento atual: ${data.toString()}');

      // Verificar se existe o array environments
      if (!data.containsKey('environments')) {
        Logger().e('Campo environments não encontrado');
        throw Exception('Estrutura do documento inválida');
      }

      final environments =
          List<Map<String, dynamic>>.from(data['environments'] ?? []);
      Logger().d('Ambientes encontrados: ${environments.length}');

      // Log de todos os IDs de ambiente
      Logger()
          .d('IDs dos ambientes: ${environments.map((e) => e['id']).toList()}');

      // Encontrar o ambiente correto
      final envIndex = environments
          .indexWhere((env) => env['id'].toString() == environmentId);
      Logger().d('Índice do ambiente encontrado: $envIndex');

      if (envIndex == -1) {
        Logger().e('Ambiente $environmentId não encontrado na lista');
        throw Exception('Ambiente não encontrado');
      }

      // Converter imagem para Map
      final imageMap = {
        'id': imagem.id,
        'filePath': imagem.filePath,
        'creationDate': imagem.creationDate.toIso8601String(),
        'dateTime': imagem.dateTime.toIso8601String(),
        'description': imagem.description,
      };

      // Inicializar array de imagens se necessário
      if (!environments[envIndex].containsKey('images')) {
        environments[envIndex]['images'] = [];
      }

      // Adicionar imagem
      environments[envIndex]['images'].add(imageMap);

      // Log da atualização
      Logger().d('Atualizando documento com: ${environments[envIndex]}');

      // Atualizar documento
      await docRef.update({'environments': environments});

      Logger().d('Imagem adicionada com sucesso ao ambiente');
    } catch (e) {
      Logger().e('Erro ao adicionar imagem ao ambiente: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(
      String visitId, String environmentId, ImagensObject imagem) async {
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

  Future<void> _removeImageFromEnvironment(
      String visitId, String environmentId, String imageId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final environments = dados['environments'] as List<dynamic>;

      final environmentIndex = environments
          .indexWhere((env) => env['id'].toString() == environmentId);

      if (environmentIndex == -1) {
        throw Exception('Ambiente não encontrado');
      }

      // Remover imagem do ambiente
      if (environments[environmentIndex]['imagens'] != null) {
        List<Map<String, dynamic>> imagens = List<Map<String, dynamic>>.from(
            environments[environmentIndex]['imagens']);
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

  Future<void> updateImageDescription(String visitId, String environmentId,
      String imageId, String newDescription) async {
    try {
      final docRef = _firestore.collection(_collection).doc(visitId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw Exception('Visita não encontrada');
      }

      final dados = docSnap.data()!;
      final environments = dados['environments'] as List<dynamic>;

      final environmentIndex = environments
          .indexWhere((env) => env['id'].toString() == environmentId);

      if (environmentIndex == -1) {
        throw Exception('Ambiente não encontrado');
      }

      // Atualizar descrição da imagem
      if (environments[environmentIndex]['imagens'] != null) {
        List<Map<String, dynamic>> imagens = List<Map<String, dynamic>>.from(
            environments[environmentIndex]['imagens']);

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
