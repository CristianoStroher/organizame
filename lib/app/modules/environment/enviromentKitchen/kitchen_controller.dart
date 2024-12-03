import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as core;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';

class KitchenController extends DefautChangeNotifer {
  final TechnicalVisitController _controller;
  final EnviromentImagesService _imagenService;
  final List<ImagensObject> _listaImagens = [];
  EnviromentObject? _currentEnvironment;

  List<ImagensObject> get listaImagens => List.unmodifiable(_listaImagens);
  EnviromentObject? get currentEnvironment => _currentEnvironment;

  KitchenController({
     required TechnicalVisitController controller,
    required EnviromentImagesService imagenService,
  })  : _controller = controller,
        _imagenService = imagenService {
    _initializeEnvironment();
  }

  //? Método para inicializar o ambiente
  Future<void> _initializeEnvironment() async {
    try {
      await _controller.ensureCurrentVisit(); // Wait for this
      _currentEnvironment = _controller.currentEnvironment;

      if (_currentEnvironment == null) {
        String newId = DateTime.now().millisecondsSinceEpoch.toString();
        Logger().d('Criando novo ambiente com ID: $newId');

        _currentEnvironment = EnviromentObject(
          id: newId,
          name: 'COZINHA',
          descroiption: '',
          itens: {},
          imagens: [],
        );

        Logger().d('Novo ambiente salvo com ID: $newId');
      }

      Logger().d('Ambiente inicializado com ID: ${_currentEnvironment?.id}');
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao inicializar ambiente: $e');
      rethrow;
    }
  }

  //? Método para obter o ID da visita atual
  String? _getCurrentVisitId() {
    return _controller.currentVisit?.id;
  }

  //? Método para validar o estado atual do controller
  void _validateCurrentState() {
    final visitId = _getCurrentVisitId();
    if (visitId == null) {
      throw Exception('Visita não selecionada no controller');
    }
    if (_currentEnvironment == null) {
      throw Exception('Ambiente não inicializado');
    }
  }

  //? Salva o ambiente no Firestore usa função addEnvironment do controller
  Future<EnviromentObject> saveEnvironment({
    //quando o ambiente é salvo, ele é salvo com esses dados
    required String description,
    required String metragem,
    String? difficulty,
    String? observation,
    required Map<String, bool> selectedItens,
    List<ImagensObject> listaImagens = const [],
  }) async {
    try {
      Logger().d('ChildBedroomController - Iniciando salvando ambiente');
      showLoadingAndResetState();
      final visitId = _getCurrentVisitId();
      if (visitId == null) {
        throw Exception('Visita não selecionada no controller');
      }

      Logger().d('ChildBedroomController - Salvando ambiente');
      Logger().d('Visit ID: $visitId');
      Logger().d('Current Environment ID: ${_currentEnvironment?.id}');

      // Usar o ID existente ou criar um novo
      final environmentId = _currentEnvironment?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      Logger().d('Usando environment ID: $environmentId');

      final environment = EnviromentObject(
        id: environmentId, // Usar o ID existente
        name: 'COZINHA',
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
        imagens: listaImagens ?? [], // Manter imagens existentes
      );
      Logger().d('Ambiente criado: $environment');
      Logger().d('Salvando ambiente com ID: ${environment.id}');
      await _controller.addEnvironment(environment);
      _currentEnvironment = environment;

      success();
      return environment;
    } catch (e) {
      setError('Erro ao salvar ambiente: $e');
      Logger().e('Erro ao salvar ambiente: $e');
      Logger().e('Estado do controller: ${_getCurrentVisitId()}');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }  

  //! Método para atualizar o ambiente no Firestore usando a função updateEnvironment do visit controller
  Future<void> updateEnvironment(EnviromentObject environment) async {
    try {
      showLoadingAndResetState();
      Logger().d('ChildBedroomController - Iniciando atualização do ambiente');

      final visitId = _getCurrentVisitId();
      if (visitId == null) {
        throw Exception('Visita não selecionada no controller');
      }

      await _controller.updateEnvironment(environment);
      _currentEnvironment = environment;

      success();
      Logger().d('ChildBedroomController - Ambiente atualizado com sucesso');
    } catch (e) {
      setError('Erro ao atualizar ambiente: $e');
      Logger().e('ChildBedroomController - Erro ao atualizar ambiente: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  //? Método para capturar uma imagem da câmera e adicionar à lista de imagens
  Future<void> captureImage({required String description}) async {
    try {
      Logger().d('Iniciando captura com descrição: $description');

      final ImagePicker picker = ImagePicker();
      final XFile? foto = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (foto == null) {
        throw Exception('Nenhuma imagem foi capturada');
      }

      // Cria o objeto de imagem
      final novaImagem = ImagensObject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: foto.path,
        description: description,
        creationDate: DateTime.now(),
        dateTime: DateTime.now(),
      );

      // Adiciona à lista local
      _listaImagens.add(novaImagem);
      notifyListeners(); // Importante para atualizar a UI

      Logger().d('Imagem capturada: ${foto.path}');
      Logger().d('Total de imagens na lista: ${_listaImagens.length}');
    } catch (e) {
      Logger().e('Erro ao capturar imagem: $e');
      rethrow;
    }
  }

  //? Método para remover uma imagem específica da lista
  void removeImagem(String id) {
    _listaImagens.removeWhere((imagem) => imagem.id == id);
  }

  Future<void> deleteImage(ImagensObject imagem) async {
  try {
    Logger().d('Iniciando exclusão da imagem: ${imagem.id}');
    showLoadingAndResetState();

    // Se a imagem está na lista local
    if (_listaImagens.any((img) => img.id == imagem.id)) {
      _listaImagens.removeWhere((img) => img.id == imagem.id);
      
      // Se for arquivo local, tenta deletar
      try {
        final file = File(imagem.filePath);
        if (await file.exists()) {
          await file.delete();
          Logger().d('Arquivo local deletado: ${imagem.filePath}');
        }
      } catch (e) {
        Logger().e('Erro ao deletar arquivo local: $e');
      }
      
      notifyListeners();
      success();
      return;
    }

    // Se a imagem está no ambiente atual (já salva)
    if (_currentEnvironment?.imagens?.any((img) => img.id == imagem.id) ?? false) {
      final visitId = _getCurrentVisitId();
      if (visitId == null) {
        throw Exception('Visita não selecionada');
      }

      // Remove do Storage se for uma URL
      if (imagem.filePath.startsWith('http')) {
        await _imagenService.deleteImage(
          visitId,
          _currentEnvironment!.id,
          imagem,
        );
      }

      // Remove da lista de imagens do ambiente
      final updatedImages = _currentEnvironment!.imagens!
          .where((img) => img.id != imagem.id)
          .toList();

      // Atualiza o ambiente
      _currentEnvironment = _currentEnvironment!.copyWith(
        imagens: updatedImages,
      );

      // Salva as alterações
      await _controller.updateEnvironment(_currentEnvironment!);
      
      success();
      notifyListeners();
      return;
    }

    throw Exception('Imagem não encontrada');

  } catch (e) {
    Logger().e('Erro ao deletar imagem: $e');
    setError('Erro ao deletar imagem: $e');
    rethrow;
  } finally {
    hideLoading();
  }
}

//! Função para atualizar a descrição de uma imagem - não verificada
  Future<void> updateImageDescription(
      String imageId, String newDescription) async {
    try {
      showLoadingAndResetState();
      _validateCurrentState();

      final visitId = _getCurrentVisitId()!;
      final environmentId = _currentEnvironment!.id;

      await _imagenService.updateImageDescription(
        visitId,
        environmentId,
        imageId,
        newDescription,
      );

      // Criar uma nova lista tipada corretamente
      List<ImagensObject> currentImages =
          List<ImagensObject>.from(_currentEnvironment?.imagens ?? []);

      // Atualizar a descrição da imagem
      final updatedImages = currentImages.map((img) {
        if (img.id == imageId) {
          return ImagensObject(
            id: img.id,
            filePath: img.filePath,
            creationDate: img.creationDate,
            dateTime: img.dateTime,
            description: newDescription,
          );
        }
        return img;
      }).toList();

      // Atualizar o ambiente com a nova lista tipada
      _currentEnvironment = _currentEnvironment!.copyWith(
        imagens: updatedImages,
      );

      await updateEnvironment(_currentEnvironment!);

      success();
    } catch (e) {
      setError('Erro ao atualizar descrição: $e');
      Logger().e('Erro ao atualizar descrição da imagem: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  void setCurrentEnvironment(EnviromentObject environment) {
    _currentEnvironment = environment;

    if (environment.imagens != null) {
      for (var imagem in environment.imagens!) {
        if (!_listaImagens.any((img) => img.id == imagem.id)) {
          _listaImagens.add(imagem);
        }
      }
      
    }

    notifyListeners();
  }

  Future<void> refreshEnvironment() async {
    final visitId = _getCurrentVisitId();
    if (_currentEnvironment != null && visitId != null) {
      try {
        showLoadingAndResetState();
        // Aqui você pode implementar a lógica para recarregar o ambiente
        // por exemplo, buscando novamente do Firestore
        success();
      } catch (e) {
        setError('Erro ao atualizar ambiente: $e');
        Logger().e('Erro ao atualizar ambiente: $e');
      } finally {
        hideLoading();
        notifyListeners();
      }
    }
  }

  

  Future<bool> verifyEnvironmentExists(String environmentId) async {
    try {
      final environment = await _controller.getEnvironment(environmentId);
      return environment != null;
    } catch (e) {
      Logger().e('Erro ao verificar existência do ambiente: $e');
      return false;
    }
  }

  void addImageToList(ImagensObject imagem) {
    if (!_listaImagens.any((img) => img.id == imagem.id)) {
      _listaImagens.add(imagem);
      notifyListeners();
    }
  }

  Future<String> uploadPhoto(File image, String fileName) async {
    try {
      // Gerar nome único para o arquivo
      String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Referência ao caminho no Firebase Storage
      var ref = storage.FirebaseStorage.instance.ref('visits/$uniqueFileName');

      // Fazendo o upload do arquivo
      await ref.putFile(image);

      // Retorna o URL de download do arquivo enviado
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl; // Retorna o URL do arquivo para o uso posterior
    } on core.FirebaseException catch (e) {
      print('Erro no upload: $e');
      return 'Erro ao fazer upload da imagem';
    }
  }

  
}