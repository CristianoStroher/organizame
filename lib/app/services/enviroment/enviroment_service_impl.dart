// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:organizame/app/models/enviroment_object2.dart';
import 'package:organizame/app/repositories/enviroment/enviroment_repository.dart';

import './enviroment_service.dart';

class EnviromentServiceImpl extends EnviromentService {
  final EnviromentRepository _enviromentRepository;

  EnviromentServiceImpl({
    required EnviromentRepository enviromentRepository,
  }) : _enviromentRepository = enviromentRepository;

  @override
  Future<void> saveEnviroment(EnviromentObject2 enviromentObject2) async {
    if (!enviromentObject2.isValid()) {
      throw ArgumentError('Ambiente inválido');
    }
    await _enviromentRepository.saveEnviroment(enviromentObject2);
  }
}
