// arquivo: environment_object2.dart

import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';

class EnviromentObject {
  final String id;
  final String nome;
  final String descricao;
  final String? metragem;
  final String? dificuldade;
  final String? observacao;
  final Map<EnviromentItensEnum, bool> itens;

  EnviromentObject({
    required this.id,
    required this.nome,
    required this.descricao,
    this.metragem,
    this.dificuldade,
    this.observacao,
    Map<EnviromentItensEnum, bool>? itens,
  }) : itens = itens ?? {};

  factory EnviromentObject.fromMap(Map<String, dynamic> map) {
    try {
      return EnviromentObject(
        id: map['id'] as String,
        nome: map['nome'] as String,
        descricao: map['descricao'] as String,
        metragem: map['metragem'] as String?,
        dificuldade: map['dificuldade'] as String?,
        observacao: map['observacao'] as String?,
        itens: (map['itens'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                  EnviromentItensEnum.values.firstWhere((e) => e.name == key),
                  value as bool),
            ) ?? {},
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para EnviromentObject2: $e');
      rethrow;
    }
  }

  factory EnviromentObject.fromFirestore(Map<String, dynamic> map) {
    return EnviromentObject.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'metragem': metragem,
      'dificuldade': dificuldade,
      'observacao': observacao,
      'itens': itens.map((key, value) => MapEntry(key.name, value)),
    };
  }

  EnviromentObject copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? metragem,
    String? dificuldade,
    String? observacao,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    return EnviromentObject(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      metragem: metragem ?? this.metragem,
      dificuldade: dificuldade ?? this.dificuldade,
      observacao: observacao ?? this.observacao,
      itens: itens ?? Map.from(this.itens),
    );
  }

  bool isValid() {
    return id.isNotEmpty && nome.isNotEmpty && descricao.isNotEmpty;
  }

  bool? getItem(EnviromentItensEnum item) {
    return itens[item];
  }

  void setItem(EnviromentItensEnum item, bool value) {
    itens[item] = value;
  }

  @override
  String toString() {
    return 'EnviromentObject2(id: $id, nome: $nome, descricao: $descricao, metragem: $metragem, dificuldade: $dificuldade, observacao: $observacao, itens: $itens)';
  }
}
