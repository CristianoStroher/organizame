import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';

class VisitHeader extends StatefulWidget {
  const VisitHeader({super.key});

  @override
  _VisitHeaderState createState() => _VisitHeaderState();
}

class _VisitHeaderState extends State<VisitHeader> {
  List<String> clients = ['Cliente 1', 'Cliente 2', 'Cliente 3'];
  String? selectedClient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOVA VISITA TÉCNICA', style: context.titleDefaut),
          const SizedBox(height: 20),
          OrganizameDropdownfield(
            label: 'Cliente',
            clients: clients,
            selectedClient: selectedClient,
            onChanged: (newValue) {
              setState(() {
                selectedClient = newValue; // Atualiza o cliente selecionado
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, selecione um cliente';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Telefone',
            hintText: '(99) 99999-9999',
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Endereço',
            hintText: 'Rua, número, bairro',
          ),
          const SizedBox(height: 20),
          OrganizameElevatedButton(
            onPressed: () {
              // Ação para adicionar o cliente
            },
            label: 'Adicionar Cliente',
            textColor: const Color(0xFFFAFFC5),
          ),
        ],
      ),
    );
  }
}
