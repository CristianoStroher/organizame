import 'package:logger/logger.dart';
import 'package:organizame/app/models/enviroment_imagens.dart';
import 'package:organizame/app/models/enviroment_itens_enum.dart';

class EnviromentObject {
  final String id;
  final String name;
  final String descroiption;
  final String? metragem;
  final String? difficulty;
  final String? observation;
  final Map<String, bool>? itens;
  final List<EnviromentImagens>? imagens;

  EnviromentObject({
    required this.id,
    required this.name,
    required this.descroiption,
    this.metragem,
    this.difficulty,
    this.observation,
    this.itens,
    this.imagens,
  });

  factory EnviromentObject.fromMap(Map<String, dynamic> map) {
    try {
      // Logger().d('Convertendo map para EnviromentObject: $map');
      return EnviromentObject(
        id: map['id'] as String,
        name: (map['name'] as String).toUpperCase(),
        descroiption: map['description'] as String,
        metragem: map['metragem'] as String?,
        difficulty: map['difficulty'] as String?,
        observation: map['observation'] as String?,
        itens: map['itens'] != null 
            ? Map<String, bool>.from(map['itens'] as Map<dynamic, dynamic>) 
            : null,
        imagens: map['imagens'] != null
            ? (map['imagens'] as List<dynamic>).map((imgMap) {
                return EnviromentImagens.fromJson(imgMap as Map<String, dynamic>);
              }).toList()
            : null,        
      );
    } catch (e) {
      Logger().e('Erro ao converter de Map para EnviromentObject: $e');
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
      'itens': itens,
      'imagens': imagens?.map((img) => img.toJson()).toList(),
    };
  }

  EnviromentObject copyWith({
    String? id,
    String? name,
    String? descroiption,
    String? metragem,
    String? difficulty,
    String? observation,
    Map<String, bool>? itens,
    List<EnviromentImagens>? imagens,
  }) {
    return EnviromentObject(
      id: id ?? this.id,
      name: name ?? this.name,
      descroiption: descroiption ?? this.descroiption,
      metragem: metragem ?? this.metragem,
      difficulty: difficulty ?? this.difficulty, // Corrigido
      observation: observation ?? this.observation, // Corrigido
      itens: itens ?? (this.itens != null ? Map<String, bool>.from(this.itens!) : null),
      imagens: imagens ?? this.imagens,
    );
  }

  bool isValid() {
    return id.isNotEmpty && name.isNotEmpty && descroiption.isNotEmpty;
  }

  bool? getItem(EnviromentItensEnum item) {
    return itens?[item.name];  // Corrigido para usar item.name
  }

  Map<String, bool> setItem(EnviromentItensEnum item, bool value) {
    final newItens = Map<String, bool>.from(itens ?? {});
    newItens[item.name] = value;  // Corrigido para usar item.name
    return newItens;
  }

  // Helper methods para imagens
  List<EnviromentImagens> addImagem(EnviromentImagens novaImagem) {
    final listaAtual = List<EnviromentImagens>.from(imagens ?? []);
    listaAtual.add(novaImagem);
    return listaAtual;
  }

  List<EnviromentImagens> removeImagem(String imagemId) {
    final listaAtual = List<EnviromentImagens>.from(imagens ?? []);
    listaAtual.removeWhere((img) => img.id == imagemId);
    return listaAtual;
  }

   List<EnviromentImagens> updateImagem(EnviromentImagens imagemAtualizada) {
    final listaAtual = List<EnviromentImagens>.from(imagens ?? []);
    final index = listaAtual.indexWhere((img) => img.id == imagemAtualizada.id);
    if (index != -1) {
      listaAtual[index] = imagemAtualizada;
    }
    return listaAtual;
  }

  // Helper methods para conversão de itens
  Map<EnviromentItensEnum, bool> getItensAsEnum() {
    final enumMap = <EnviromentItensEnum, bool>{};
    if (itens != null) {
      for (final item in EnviromentItensEnum.values) {
        if (itens!.containsKey(item.name)) {
          enumMap[item] = itens![item.name]!;
        }
      }
    }
    return enumMap;
  }

  static Map<String, bool> convertEnumMapToStringMap(Map<EnviromentItensEnum, bool> enumMap) {
    return Map<String, bool>.fromEntries(
      enumMap.entries.map((entry) => MapEntry(entry.key.name, entry.value))
    );
  }

  @override
  String toString() {
    return 'EnviromentObject(id: $id, nome: $name, descricao: $descroiption, '
           'metragem: $metragem, dificuldade: $difficulty, '
           'observacao: $observation, itens: $itens,'
           'imagens: ${imagens?.length ?? 0} imagens)';
  }
  
}