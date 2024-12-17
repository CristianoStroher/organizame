enum EnviromentItensEnum {

  alimentos,
  acessorios,
  bebidas,
  brinquedos,
  calcados,
  eletrodomesticos,
  itensDeMesa,
  loucas,
  maquiagem,
  outros,
  panelas,
  panosDePrato,
  produtosDeLimpeza,
  roupas,
  roupasDeCama,
  utensilios,
  utensiliosDeLimpeza
}
  
//essa função serve para pegar o nome do enum e transformar em string
extension EnviromentItensEnumExtension on EnviromentItensEnum {
  
  String get name {
    return this.toString().split('.').last;
}

String get displayName {
  switch (this) {
    case EnviromentItensEnum.alimentos:
      return 'Alimentos';
    case EnviromentItensEnum.acessorios:
      return 'Acessórios';
    case EnviromentItensEnum.bebidas:
      return 'Bebidas';
    case EnviromentItensEnum.brinquedos:
      return 'Brinquedos';
    case EnviromentItensEnum.calcados:
      return 'Calçados';
    case EnviromentItensEnum.eletrodomesticos:
      return 'Eletrodomésticos';
    case EnviromentItensEnum.itensDeMesa:
      return 'Itens de Mesa';
    case EnviromentItensEnum.loucas:
      return 'Louças';
    case EnviromentItensEnum.maquiagem:
      return 'Maquiagem';
    case EnviromentItensEnum.outros:
      return 'Outros';
    case EnviromentItensEnum.panelas:
      return 'Panelas';
    case EnviromentItensEnum.panosDePrato:
      return 'Panos de Prato';
    case EnviromentItensEnum.produtosDeLimpeza:
      return 'Produtos de Limpeza';
    case EnviromentItensEnum.roupas:
      return 'Roupas';
    case EnviromentItensEnum.roupasDeCama:
      return 'Roupas de Cama';
    case EnviromentItensEnum.utensilios:
      return 'Utensílios';
    case EnviromentItensEnum.utensiliosDeLimpeza:
      return 'Utensílios de Limpeza';
    default:
      return name.substring(0, 1).toUpperCase() + name.substring(1);
  }
}


}