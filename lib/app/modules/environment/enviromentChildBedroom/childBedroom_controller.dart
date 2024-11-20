import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as core;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/models/enviroment_object.dart';
import 'package:organizame/app/modules/tecnicalVisit/technicalVisit_controller.dart';
import 'package:organizame/app/services/enviromentImages/enviroment_images_service.dart';

class ChildBedroomController extends DefautChangeNotifer {
  final TechnicalVisitController _controller;
  final EnviromentImagesService _imagenService;
  EnviromentObject? _currentEnvironment;

  EnviromentObject? get currentEnvironment => _currentEnvironment;

  ChildBedroomController({
    required TechnicalVisitController controller,
    required EnviromentImagesService imagenService,
  })  : _controller = controller,
        _imagenService = imagenService {
    _initializeEnvironment();
  }

  Future<void> _initializeEnvironment() async {
    try {
      await _controller.ensureCurrentVisit(); // Wait for this
      _currentEnvironment = _controller.currentEnvironment;

      if (_currentEnvironment == null) {
        String newId = DateTime.now().millisecondsSinceEpoch.toString();
        Logger().d('Criando novo ambiente com ID: $newId');

        _currentEnvironment = EnviromentObject(
          id: newId,
          name: 'QUARTO CRIANÇA',
          descroiption: '',
          itens: {},
          imagens: [],
        );

        // Save the new environment immediately
        await _controller.addEnvironment(_currentEnvironment!);
        Logger().d('Novo ambiente salvo com ID: $newId');
      }

      Logger().d('Ambiente inicializado com ID: ${_currentEnvironment?.id}');
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao inicializar ambiente: $e');
      rethrow;
    }
  }

  String? _getCurrentVisitId() {
    return _controller.currentVisit?.id;
  }

  void _validateCurrentState() {
    final visitId = _getCurrentVisitId();
    if (visitId == null) {
      throw Exception('Visita não selecionada no controller');
    }
    if (_currentEnvironment == null) {
      throw Exception('Ambiente não inicializado');
    }
  }

  // Salva o ambiente no Firestore usa função addEnvironment do controller
  Future<EnviromentObject> saveEnvironment({
    required String description,
    required String metragem,
    String? difficulty,
    String? observation,
    required Map<String, bool> selectedItens,
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
        name: 'QUARTO DE CRIANÇA',
        descroiption: description,
        metragem: metragem,
        difficulty: difficulty,
        observation: observation,
        itens: selectedItens,
        imagens: _currentEnvironment?.imagens ?? [], // Manter imagens existentes
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

  Future<ImagensObject?> captureAndUploadImage(String description) async {
    try {
      Logger().d('Debug - Environment antes: ${_currentEnvironment?.id}');
      showLoadingAndResetState();

      // Ensure visit and environment are initialized
      await _controller.ensureCurrentVisit();
      if (_currentEnvironment == null) {
        await _initializeEnvironment();
        throw Exception('Ambiente não inicializado');
      }

      final visitId = _getCurrentVisitId();
      final environmentId = _currentEnvironment?.id;

      if (visitId == null || environmentId == null) {
        throw Exception('VisitId ou EnvironmentId são inválidos');
      }

      // Verify environment exists in the controller
      final existingEnvironment = _controller.getEnvironment(environmentId);
      if (existingEnvironment == null) {
        Logger().d('Ambiente não encontrado, tentando adicionar novamente');
        await _controller.addEnvironment(_currentEnvironment!);
      }

      // Capture image
      final ImagePicker picker = ImagePicker();
      final XFile? foto = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (foto == null) {
        throw Exception('Nenhuma imagem foi capturada');
      }

      Logger().d('Imagem capturada: ${foto.path}');

      // Upload image
      final imagem = await _imagenService.uploadImage(
        visitId,
        environmentId,
        File(foto.path),
        description,
      );

      Logger().d('Imagem enviada com sucesso: ${imagem.id}');

      // Update current environment with new image
      List<ImagensObject> currentImages = List<ImagensObject>.from(_currentEnvironment?.imagens ?? []);
      currentImages.add(imagem);

      _currentEnvironment = _currentEnvironment!.copyWith(imagens: currentImages);

      // Update environment in controller
      await _controller.updateEnvironment(_currentEnvironment!);
      

      success();
      
      return imagem;
    } catch (e) {
      Logger().e('Erro ao capturar ou enviar imagem: $e');
      setError('Erro ao capturar ou enviar imagem: $e');
      return null;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> deleteImage(ImagensObject imagem) async {
    try {
      showLoadingAndResetState();
      _validateCurrentState();

      final visitId = _getCurrentVisitId()!;
      final environmentId = _currentEnvironment!.id;

      await _imagenService.deleteImage(
        visitId,
        environmentId,
        imagem,
      );

      // Criar uma nova lista tipada corretamente
      List<ImagensObject> currentImages =
          List<ImagensObject>.from(_currentEnvironment?.imagens ?? []);
      currentImages.removeWhere((img) => img.id == imagem.id);

      // Atualizar o ambiente com a nova lista tipada
      _currentEnvironment = _currentEnvironment!.copyWith(
        imagens: currentImages,
      );

      await updateEnvironment(_currentEnvironment!);

      success();
    } catch (e) {
      setError('Erro ao deletar imagem: $e');
      Logger().e('Erro ao deletar imagem: $e');
      rethrow;
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

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

  Future<bool> verifyEnvironmentExists(String environmentId) async {
    try {
      final environment = await _controller.getEnvironment(environmentId);
      return environment != null;
    } catch (e) {
      Logger().e('Erro ao verificar existência do ambiente: $e');
      return false;
    }
  }
}
