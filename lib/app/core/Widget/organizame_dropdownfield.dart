import 'dart:math';

import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameDropdownfield extends StatelessWidget {
  final String label;
  final List<String> options; // Lista de clientes
  final String? selectedOptions; // Cliente selecionado
  final ValueChanged<String?>? onChanged; // Função que executa quando cliente é selecionado
  final FormFieldValidator<String>? validator;
  final bool enabled; // Mudei para booleano não-nulo

  const OrganizameDropdownfield({
    super.key,
    required this.label,
    required this.options,
    this.selectedOptions,
    this.onChanged,
    this.validator,
    this.enabled = true, // Valor padrão
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedOptions,
      decoration: InputDecoration(
        enabled: enabled, // Habilita ou desabilita
        labelText: label,
        labelStyle: TextStyle(
          color: context.primaryColor,
          fontSize: context.titleDefaut.fontSize,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(
            color: context.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(
            color: context.primaryColor,
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
      onChanged: enabled ? onChanged : null, // Verifica se está habilitado
      items: options
          .map(
            (client) => DropdownMenuItem<String>(
              value: client,
              child: Text(client),
            ),
          )
          .toList(),
      isExpanded: true, // Para usar a largura completa
    );
  }
}
