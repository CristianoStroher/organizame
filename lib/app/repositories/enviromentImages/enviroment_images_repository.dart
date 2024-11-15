import 'dart:io';

import 'package:organizame/app/models/enviroment_imagens.dart';

abstract class EnviromentImagesRepository {
  
  Future<EnviromentImagens> uploadImage(String visitId, String environmentId, File imageFile, String description);
  Future<void> _addImageToEnvironment(String visitId, String environmentId, EnviromentImagens imagem); 
  Future<void> deleteImage(String visitId, String environmentId, EnviromentImagens imagem);
  Future<void> _removeImageFromEnvironment(String visitId, String environmentId, String imageId);
  Future<void> updateImageDescription(String visitId, String environmentId, String imageId, String newDescription);

}
