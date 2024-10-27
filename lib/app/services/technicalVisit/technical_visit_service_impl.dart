import 'package:logger/logger.dart';
import 'package:organizame/app/models/customer_object.dart';
import 'package:organizame/app/models/technicalVisit_object.dart';
import 'package:organizame/app/modules/homeTecnical/tecnical_controller.dart';
import 'package:organizame/app/repositories/technicalVisit/technicalVisit_repository.dart';

import './technical_visit_service.dart';

class TechnicalVisitServiceImpl extends TechnicalVisitService {
  final TechnicalVisitRepository _technicalVisitRepository;

  TechnicalVisitServiceImpl({
    required TechnicalVisitRepository technicalVisitRepository,
  }) : _technicalVisitRepository = technicalVisitRepository;

  @override
  Future<void> saveTechnicalVisit(
          DateTime data, DateTime hora, CustomerObject cliente) =>
      _technicalVisitRepository.saveTechnicalVisit(data, hora, cliente);

  @override
  Future<List<TechnicalVisitObject>> getAllTechnicalVisits() =>
      _technicalVisitRepository.getAllTechnicalVisits();

  @override
  Future<bool> deleteTechnicalVisit(
          TechnicalVisitObject technicalVisitObject) =>
      _technicalVisitRepository.deleteTechnicalVisit(technicalVisitObject);

  @override
  Future<void> updateTechnicalVisit(TechnicalVisitObject technicalVisit) async {
    try {
      // Validação de ID
      if (technicalVisit.id == null) {
        Logger().e('Não é possível atualizar uma visita sem ID');
        throw Exception('Não é possível atualizar uma visita sem ID');
      }

      // Busca todas as visitas técnicas
      final List<TechnicalVisitObject> allVisits = await getAllTechnicalVisits();

      // Verifica conflito de horários
      final conflictingVisit = allVisits.where((visit) {
        // Ignora a própria visita que está sendo atualizada
        if (visit.id == technicalVisit.id) return false;

        // Verifica se é no mesmo dia
        final sameDay = visit.date.year == technicalVisit.date.year &&
            visit.date.month == technicalVisit.date.month &&
            visit.date.day == technicalVisit.date.day;

        if (!sameDay) return false;

        // Calcula a duração da visita (assumindo 1 hora por padrão)
        // Você pode ajustar esse valor conforme sua regra de negócio
        const visitDuration = Duration(hours: 1);

        // Define o intervalo da visita existente
        final existingVisitStart = DateTime(
          visit.date.year,
          visit.date.month,
          visit.date.day,
          visit.time.hour,
          visit.time.minute,
        );
        final existingVisitEnd = existingVisitStart.add(visitDuration);

        // Define o intervalo da nova visita
        final newVisitStart = DateTime(
          technicalVisit.date.year,
          technicalVisit.date.month,
          technicalVisit.date.day,
          technicalVisit.time.hour,
          technicalVisit.time.minute,
        );
        final newVisitEnd = newVisitStart.add(visitDuration);

        // Verifica se há sobreposição de horários
        return (newVisitStart.isBefore(existingVisitEnd) &&
            existingVisitStart.isBefore(newVisitEnd));
      }).firstOrNull;

      // Se encontrou conflito, lança exceção
      if (conflictingVisit != null) {
        final conflictTime = 
            '${conflictingVisit.time.hour.toString().padLeft(2, '0')}:${conflictingVisit.time.minute.toString().padLeft(2, '0')}';
        throw Exception('Já existe uma visita agendada para ${conflictingVisit.date.day}/${conflictingVisit.date.month}/${conflictingVisit.date.year} às $conflictTime');
        Logger().e('Já existe uma visita agendada para ${conflictingVisit.date.day}/${conflictingVisit.date.month}/${conflictingVisit.date.year} às $conflictTime');
      }

      // Se passou por todas as validações, atualiza a visita
      await _technicalVisitRepository.updateTechnicalVisit(technicalVisit);
    } catch (e) {
      Logger().e('Erro ao atualizar visita técnica: $e');
      throw Exception('Erro ao atualizar visita técnica: $e');
    }
  }


}
