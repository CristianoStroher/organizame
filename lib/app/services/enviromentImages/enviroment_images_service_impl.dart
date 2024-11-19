import 'dart:io';

import 'package:organizame/app/models/imagens_object.dart';
import 'package:organizame/app/repositories/enviromentImages/enviroment_images_repository.dart';

import './enviroment_images_service.dart';

class EnviromentImagesServiceImpl extends EnviromentImagesService {
  final EnviromentImagesRepository _repository;

  EnviromentImagesServiceImpl({
    required EnviromentImagesRepository repository,
  }) : _repository = repository;

  Future<ImagensObject> uploadImage(
    String visitId,
    String environmentId,
    File imageFile,
    String description
  ) async {
    return await _repository.uploadImage(
      visitId,
      environmentId,
      imageFile,
      description,
    );
  }

  Future<void> deleteImage(
    String visitId,
    String environmentId,
    ImagensObject imagem
  ) async {
    await _repository.deleteImage(visitId, environmentId, imagem);
  }

  Future<void> updateImageDescription(
    String visitId,
    String environmentId,
    String imageId,
    String newDescription
  ) async {
    await _repository.updateImageDescription(
      visitId,
      environmentId,
      imageId,
      newDescription,
    );
  }
}        
      



