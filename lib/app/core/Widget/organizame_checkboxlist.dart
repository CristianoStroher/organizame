import 'package:flutter/material.dart';

class OrganizameCheckboxlist extends StatefulWidget {
  final List<String> options; // lista de opções do checkbox
  final Color? color; // Cor do checkbox
  final Map<String, bool>? initialValues; // Valores iniciais
  final Function(Map<String, bool>)? onChanged; // Função de callback

  const OrganizameCheckboxlist({
    super.key,
    required this.options,
    this.color,
    this.initialValues,
    this.onChanged,
  });

  @override
  State<OrganizameCheckboxlist> createState() => _OrganizameCheckboxlistState();
}

class _OrganizameCheckboxlistState extends State<OrganizameCheckboxlist> {
  Map<String, bool> _checkedOptions = {};

  @override
  void initState() {
    super.initState();
    _initializeCheckboxes();
  }

  void _initializeCheckboxes() {
    if (widget.initialValues != null) {
      _checkedOptions = Map<String, bool>.from(widget.initialValues!);
    } else {
      // Se não houver valores iniciais, inicializa tudo como false
      _checkedOptions = {
        for (var option in widget.options) option: false
      };
    }
  }

  @override
  void didUpdateWidget(OrganizameCheckboxlist oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Verifica se os valores iniciais mudaram
    bool valuesChanged = false;
    if (widget.initialValues != oldWidget.initialValues) {
      if (widget.initialValues != null && oldWidget.initialValues != null) {
        // Compara os valores dos mapas
        widget.initialValues!.forEach((key, value) {
          if (oldWidget.initialValues![key] != value) {
            valuesChanged = true;
          }
        });
      } else {
        valuesChanged = true;
      }
    }

    if (valuesChanged) {
      _initializeCheckboxes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return CheckboxListTile(
          side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1),
          activeColor: Theme.of(context).primaryColor, 
          checkColor: Colors.white, 
          tileColor: widget.color ?? Colors.white, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), 
          controlAffinity: ListTileControlAffinity.leading, 
          visualDensity: VisualDensity.compact, 
          value: _checkedOptions[option] ?? false, 
          title: Text(
            option,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor),           ),
          onChanged: (bool? value) {
            setState(() {
              _checkedOptions[option] = value ?? false;
            });
            widget.onChanged?.call(Map<String, bool>.from(_checkedOptions));
          },
        );
      }).toList(),
    );
  }  
}
