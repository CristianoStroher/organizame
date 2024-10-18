
import 'package:organizame/app/models/enviroment_object2.dart';

abstract class EnviromentRepository {

  Future<void> saveEnviroment(EnviromentObject2 enviromentObject2);
    
}