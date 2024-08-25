// ignore_for_file: public_member_api_docs, sort_constructors_first

class TaskObject {
  
  final int id;
  final String descricao;
  final DateTime data;
  final DateTime hora;
  final String? observacao;
  final bool finalizado;

  TaskObject({
    required this.id,
    required this.descricao,
    required this.data,
    required this.hora,
    required this.finalizado,
    this.observacao,

  });

  factory TaskObject.fromMap(Map<String, dynamic> map) {
    return TaskObject(
      id: map['id'] as int,
      descricao: map['descricao'] as String,
      data: DateTime.parse(map['data'] as String),
      hora: DateTime.parse(map['hora'] as String),
      finalizado: map['finalizado'] == 1,
      observacao: map['observacao'] as String?,
    );
  }
 
}
