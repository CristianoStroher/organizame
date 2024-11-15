import 'dart:io';

import 'package:organizame/app/models/enviroment_imagens.dart';

abstract class EnviromentImagesService {

  Future<EnviromentImagens> uploadImage(String visitId, String environmentId, File imageFile, String description);
  Future<void> deleteImage(String visitId, String environmentId, EnviromentImagens imagem);
  Future<void> updateImageDescription(String visitId, String environmentId, String imageId, String newDescription);


}