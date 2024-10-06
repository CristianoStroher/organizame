import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class TaskObject {
  final int? id;
  final String descricao;
  final DateTime data;
  final DateTime hora;
  final String? observacao;
  final bool finalizado;

  TaskObject({
    this.id,
    required this.descricao,
    required this.data,
    required this.hora,
    required this.finalizado,
    this.observacao,
  });

  // Construtor de fábrica que será usado para converter um mapa em um objeto
  factory TaskObject.fromMap(Map<String, dynamic> map) {
    try {
      // Verificar se os campos existem e têm o formato esperado
      final dateStr = map['data'] as String?;
      final timeStr = map['hora'] as String?;

      if (dateStr == null || timeStr == null) {
        throw ArgumentError('Campos obrigatórios ausentes');
      }

      final date = DateTime.parse(dateStr);
      final time = DateFormat('HH:mm:ss').parse(timeStr);

      // Combine data e hora
      final combinedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute, time.second);
      // Retorna o objeto
      return TaskObject(
        id: map['id'] as int?,
        descricao: map['descricao'] as String,
        data: date,
        hora: combinedDateTime, // Ajuste para armazenar data e hora combinadas
        observacao: map['observacao'] as String?,
        finalizado: (map['finalizado'] as int) == 1,
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para TaskObject: $e');
      rethrow;
    }
  }

  // Converte o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'data': DateFormat('yyyy-MM-dd').format(data),
      'hora': DateFormat('HH:mm:ss').format(hora),
      'observacao': observacao,
      'finalizado': finalizado ? 1 : 0,
    };
  }

  // Cria uma cópia do objeto com os campos atualizados
  TaskObject copyWith({
    int? id,
    String? descricao,
    DateTime? data,
    DateTime? hora,
    String? observacao,
    bool? finalizado,
  }) {
    return TaskObject(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      hora: hora ?? this.hora,
      observacao: observacao ?? this.observacao,
      finalizado: finalizado ?? this.finalizado,
    );
  }
}
