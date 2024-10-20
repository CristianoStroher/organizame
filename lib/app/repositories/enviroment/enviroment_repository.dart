
import 'package:organizame/app/models/enviroment_object.dart';

abstract class EnviromentRepository {

  Future<void> saveEnviroment(EnviromentObject enviromentObject2);
    
}