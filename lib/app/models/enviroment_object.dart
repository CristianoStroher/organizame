// arquivo: environment_object2.dart

import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';

class EnviromentObject {
  final String id;
  final String name;
  final String descroiption;
  final String? metragem;
  final String? difficulty;
  final String? observation;
  final Map<EnviromentItensEnum, bool> itens;

  EnviromentObject({
    required this.id,
    required this.name,
    required this.descroiption,
    this.metragem,
    this.difficulty,
    this.observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) : itens = itens ?? {};

  factory EnviromentObject.fromMap(Map<String, dynamic> map) {
    try {
      return EnviromentObject(
        id: map['id'] as String,
        name: map['name'] as String,
        descroiption: map['description'] as String,
        metragem: map['metragem'] as String?,
        difficulty: map['difficulty'] as String?,
        observation: map['observation'] as String?,
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
      'name': name,
      'description': descroiption,
      'metragem': metragem,
      'difficulty': difficulty,
      'observation': observation,
      'itens': itens.map((key, value) => MapEntry(key.name, value)),
    };
  }

  EnviromentObject copyWith({
    String? id,
    String? name,
    String? descroiption,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<EnviromentItensEnum, bool>? itens,
  }) {
    return EnviromentObject(
      id: id ?? this.id,
      name: name ?? this.name,
      descroiption: descroiption ?? this.descroiption,
      metragem: metragem ?? this.metragem,
      difficulty: difficulty ?? difficulty,
      observation: observation ?? observation,
      itens: itens ?? Map.from(this.itens),
    );
  }

  bool isValid() {
    return id.isNotEmpty && name.isNotEmpty && descroiption.isNotEmpty;
  }  

  bool? getItem(EnviromentItensEnum item) {
    return itens[item];
  }

  void setItem(EnviromentItensEnum item, bool value) {
    itens[item] = value;
  }

  @override
  String toString() {
    return 'EnviromentObject2(id: $id, nome: $name, descricao: $descroiption, metragem: $metragem, dificuldade: $difficulty, observacao: $observation, itens: $itens)';
  }
}
