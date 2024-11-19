import 'dart:io';

import 'package:organizame/app/models/imagens_object.dart';

abstract class EnviromentImagesService {

  Future<ImagensObject> uploadImage(String visitId, String environmentId, File imageFile, String description);
  Future<void> deleteImage(String visitId, String environmentId, ImagensObject imagem);
  Future<void> updateImageDescription(String visitId, String environmentId, String imageId, String newDescription);


}