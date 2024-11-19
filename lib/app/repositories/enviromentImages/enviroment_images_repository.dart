import 'dart:io';

import 'package:organizame/app/models/imagens_object.dart';

abstract class EnviromentImagesRepository {
  
  Future<ImagensObject> uploadImage(String visitId, String environmentId, File imageFile, String description);
  Future<void> _addImageToEnvironment(String visitId, String environmentId, ImagensObject imagem); 
  Future<void> deleteImage(String visitId, String environmentId, ImagensObject imagem);
  Future<void> _removeImageFromEnvironment(String visitId, String environmentId, String imageId);
  Future<void> updateImageDescription(String visitId, String environmentId, String imageId, String newDescription);

}
