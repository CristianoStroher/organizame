// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  factory TaskObject.fromMap(Map<String, dynamic> map) {
  final date = DateTime.parse(map['data'] as String);
  final timeStr = map['hora'] as String;
  final time = DateFormat('HH:mm:ss').parse(timeStr); // Ajuste para o formato correto
  
  // Combine a data e a hora
  final combinedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second);

  // Logs de depuração
  Logger().i('Convertendo do Map para TaskObject:');
  Logger().i('Data: $combinedDateTime');
    
  return TaskObject(
    id: map['id'] as int?,
    descricao: map['descricao'] as String,
    data: combinedDateTime, // Ajuste conforme necessário
    hora: combinedDateTime, // Ajuste conforme necessário
    observacao: map['observacao'] as String?,
    finalizado: (map['finalizado'] as int) == 1,
  );
}

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
