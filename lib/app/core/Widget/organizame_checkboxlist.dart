import 'package:flutter/material.dart';

class OrganizameCheckboxlist extends StatefulWidget {
  final List<String> options; // lista de opções do checkbox
  final Color? color; // Cor do checkbox

  const OrganizameCheckboxlist({
    super.key,
    required this.options,
    this.color,
  });

  @override
  State<OrganizameCheckboxlist> createState() => _OrganizameCheckboxlistState();
}

class _OrganizameCheckboxlistState extends State<OrganizameCheckboxlist> {
  Map<String, bool> _checkedOptions = {}; // Mapa de opções marcadas

  @override
  void initState() {
    super.initState();
    // Inicializa o mapa com as opções como chaves e seus estados como false
    _checkedOptions = {for (var option in widget.options) option: false};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return CheckboxListTile(
          side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1), // Borda do checkbox
          activeColor: Theme.of(context).primaryColor, // Cor ativa do checkbox
          checkColor: Colors.white, // Cor do check
          tileColor: widget.color ?? Colors.white, // Cor do fundo do tile
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Espaçamento interno horizontal
          controlAffinity:
              ListTileControlAffinity.leading, // Checkbox à esquerda
          visualDensity: VisualDensity.compact, // Densidade visual padrão
          value: _checkedOptions[option],
          title: Text(
            option,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor), // Estilo do texto
          ),
          onChanged: (bool? value) {
            setState(() {
              _checkedOptions[option] = value ?? false;
            });
          },
        );
      }).toList(),
    );
  }

  // Método para obter as opções selecionadas
  List<String> getSelectedOptions() {
    return _checkedOptions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
