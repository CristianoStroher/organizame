// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:logger/logger.dart';

class EnviromentObject2 {
  final String id;
  final String nome;
  final String descricao;
  final String? metragem;
  final String? dificuldade;
  final String? observacao;
  final bool? alimentos;
  final bool? acessorios;
  final bool? bebidas;
  final bool? brinquedos;
  final bool? calcados;
  final bool? eletrodomesticos;
  final bool? itensDeMesa;
  final bool? loucas;
  final bool? maquiagem;
  final bool? outros;
  final bool? panelas;
  final bool? panosDePrato;
  final bool? produtosDeLimpeza;
  final bool? roupas;
  final bool? roupasDeCama;
  final bool? utensilios;
  final bool? utensiliosDeLimpeza;

  EnviromentObject2({
    required this.id,
    required this.nome,
    required this.descricao,
    this.metragem,
    this.dificuldade,
    this.observacao,
    this.alimentos,
    this.acessorios,
    this.bebidas,
    this.brinquedos,
    this.calcados,
    this.eletrodomesticos,
    this.itensDeMesa,
    this.loucas,
    this.maquiagem,
    this.outros,
    this.panelas,
    this.panosDePrato,
    this.produtosDeLimpeza,
    this.roupas,
    this.roupasDeCama,
    this.utensilios,
    this.utensiliosDeLimpeza,
  });

  factory EnviromentObject2.fromMap(Map<String, dynamic> map) {
    try {
      return EnviromentObject2(
        id: map['id'] as String,
        nome: map['nome'] as String,
        descricao: map['descricao'] as String,
        metragem: map['metragem'] as String?,
        dificuldade: map['dificuldade'] as String?,
        observacao: map['observacao'] as String?,
        alimentos: map['alimentos'] as bool?,
        acessorios: map['acessorios'] as bool?,
        bebidas: map['bebidas'] as bool?,
        brinquedos: map['brinquedos'] as bool?,
        calcados: map['calcados'] as bool?,
        eletrodomesticos: map['eletrodomesticos'] as bool?,
        itensDeMesa: map['itensDeMesa'] as bool?,
        loucas: map['loucas'] as bool?,
        maquiagem: map['maquiagem'] as bool?,
        outros: map['outros'] as bool?,
        panelas: map['panelas'] as bool?,
        panosDePrato: map['panosDePrato'] as bool?,
        produtosDeLimpeza: map['produtosDeLimpeza'] as bool?,
        roupas: map['roupas'] as bool?,
        roupasDeCama: map['roupasDeCama'] as bool?,
        utensilios: map['utensilios'] as bool?,
        utensiliosDeLimpeza: map['utensiliosDeLimpeza'] as bool?,
      );
    } on Exception catch (e) {
      Logger().e('Erro ao converter de Map para EnviromentObject2: $e');
      rethrow; // Rethrow para que o erro seja capturado no local de chamada
    }
  }

  // Construtor de fábrica para converter um DocumentSnapshot do Firestore em um EnviromentObject2
  factory EnviromentObject2.fromFirestore(Map<String, dynamic> map) {
    return EnviromentObject2.fromMap(map);
  }

  // Converte o objeto em um mapa utizado no metodo fromMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'metragem': metragem,
      'dificuldade': dificuldade,
      'observacao': observacao,
      'alimentos': alimentos,
      'acessorios': acessorios,
      'bebidas': bebidas,
      'brinquedos': brinquedos,
      'calcados': calcados,
      'eletrodomesticos': eletrodomesticos,
      'itensDeMesa': itensDeMesa,
      'loucas': loucas,
      'maquiagem': maquiagem,
      'outros ': outros,
    };
  }

  EnviromentObject2 copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? metragem,
    String? dificuldade,
    String? observacao,
    bool? alimentos,
    bool? acessorios,
    bool? bebidas,
    bool? brinquedos,
    bool? calcados,
    bool? eletrodomesticos,
    bool? itensDeMesa,
    bool? loucas,
    bool? maquiagem,
    bool? outros,
    bool? panelas,
    bool? panosDePrato,
    bool? produtosDeLimpeza,
    bool? roupas,
    bool? roupasDeCama,
    bool? utensilios,
    bool? utensiliosDeLimpeza,
  }) {
    return EnviromentObject2(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      metragem: metragem ?? this.metragem,
      dificuldade: dificuldade ?? this.dificuldade,
      observacao: observacao ?? this.observacao,
      alimentos: alimentos ?? this.alimentos,
      acessorios: acessorios ?? this.acessorios,
      bebidas: bebidas ?? this.bebidas,
      brinquedos: brinquedos ?? this.brinquedos,
      calcados: calcados ?? this.calcados,
      eletrodomesticos: eletrodomesticos ?? this.eletrodomesticos,
      itensDeMesa: itensDeMesa ?? this.itensDeMesa,
      loucas: loucas ?? this.loucas,
      maquiagem: maquiagem ?? this.maquiagem,
      outros: outros ?? this.outros,
      panelas: panelas ?? this.panelas,
      panosDePrato: panosDePrato ?? this.panosDePrato,
      produtosDeLimpeza: produtosDeLimpeza ?? this.produtosDeLimpeza,
      roupas: roupas ?? this.roupas,
      roupasDeCama: roupasDeCama ?? this.roupasDeCama,
      utensilios: utensilios ?? this.utensilios,
      utensiliosDeLimpeza: utensiliosDeLimpeza ?? this.utensiliosDeLimpeza,
    );
  }

  bool isValid() {
    return nome.isNotEmpty && descricao.isNotEmpty;
  }

  @override
  String toString() {
    return 'EnviromentObject2(id: $id, nome: $nome, descricao: $descricao, metragem: $metragem, dificuldade: $dificuldade, observacao: $observacao, alimentos: $alimentos, acessorios: $acessorios, bebidas: $bebidas, brinquedos: $brinquedos, calcados: $calcados, eletrodomesticos: $eletrodomesticos, itensDeMesa: $itensDeMesa, loucas: $loucas, maquiagem: $maquiagem, outros: $outros, panelas: $panelas, panosDePrato: $panosDePrato, produtosDeLimpeza: $produtosDeLimpeza, roupas: $roupas, roupasDeCama: $roupasDeCama, utensilios: $utensilios, utensiliosDeLimpeza: $utensiliosDeLimpeza)';
  }
}
