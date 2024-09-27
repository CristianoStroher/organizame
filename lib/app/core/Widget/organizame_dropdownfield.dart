import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameDropdownfield extends StatelessWidget {
  final String label;
  final List<String> clients; // Lista de clientes
  final String? selectedClient; // Cliente selecionado
  final ValueChanged<String?>?
      onChanged; // Função que executa quando cliente é selecionado
  final FormFieldValidator<String>? validator;

  const OrganizameDropdownfield({
    super.key,
    required this.label,
    required this.clients,
    this.selectedClient,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedClient,
      decoration: InputDecoration(
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
      onChanged: onChanged,
      items: clients
          .map(
            (client) => DropdownMenuItem<String>(
              value: client,
              child: Text(client),
            ),
          )
          .toList(),
    );
  }
}
