import 'package:organizame/app/models/enviroment_object.dart';

abstract class EnviromentService {

  Future<void> addEnvironmentToVisit(String visitId, EnviromentObject environment);
  Future<void> removeEnvironmentFromVisit(String visitId, String environmentId);
  Future<void> updateEnvironmentInVisit(String visitId, EnviromentObject environment);

}