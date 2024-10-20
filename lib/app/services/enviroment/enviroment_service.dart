import 'package:organizame/app/models/enviroment_object.dart';

abstract class EnviromentService {
  
  Future<void> saveEnviroment(EnviromentObject enviromentObject);

} 