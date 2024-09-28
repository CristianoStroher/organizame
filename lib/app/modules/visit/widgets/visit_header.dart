import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/core/widget/organizame_dropdownfield.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/modules/task/widgets/organizame_calendar_button.dart';
import 'package:organizame/app/modules/task/widgets/organizame_time.dart';

class VisitHeader extends StatefulWidget {
  const VisitHeader({super.key});

  @override
  _VisitHeaderState createState() => _VisitHeaderState();
}

class _VisitHeaderState extends State<VisitHeader> {
  static const List<String> clients = ['Cliente 1', 'Cliente 2', 'Cliente 3'];

  String? selectedClient;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateEC = TextEditingController();
  final TextEditingController timeEC = TextEditingController();

  final Map<String, Map<String, String>> clientData = {
    'Cliente 1': {'telefone': '(11) 12345-6789', 'endereco': 'Rua A, 123'},
    'Cliente 2': {'telefone': '(21) 98765-4321', 'endereco': 'Rua B, 456'},
    'Cliente 3': {'telefone': '(31) 99999-8888', 'endereco': 'Rua C, 789'},
  };

  bool isFieldsEditable = true;

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _updateClientData(String? newValue) {
    setState(() {
      selectedClient = newValue;

      if (newValue != null && clientData.containsKey(newValue)) {
        phoneController.text = clientData[newValue]!['telefone']!;
        addressController.text = clientData[newValue]!['endereco']!;
        isFieldsEditable = false; // Desabilita os campos
      } else {
        phoneController.clear();
        addressController.clear();
        isFieldsEditable = true; // Habilita os campos
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOVA VISITA TÉCNICA', style: context.titleDefaut),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OrganizameCalendarButton(
                  controller: dateEC,
                  color: const Color(0xFFFAFFC5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OrganizameTimeButton(
                  controller: timeEC,
                  label: 'Hora',
                  color: const Color(0xFFFAFFC5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OrganizameDropdownfield(
            label: 'Cliente',
            clients: clients,
            selectedClient: selectedClient,
            onChanged: _updateClientData,
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
            controller: phoneController,
            enabled: false, // Campo completamente desabilitado
            fillColor: context.secondaryColor
                .withOpacity(0.5), // Cor de fundo azul claro
            filled: true, // Permite que o campo seja preenchido
            readOnly: true, // Adicionado para indicar que é somente leitura
            // decoration: InputDecoration(
            //   enabled: false, // Não permite interação
            //   border: InputBorder.none, // Remove a borda
            //   hintText: '(99) 99999-9999', // Sugestão de formato
            // ),
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Endereço',
            hintText: 'Rua, número, bairro',
            controller: addressController,
            enabled: false, // Campo completamente desabilitado
            fillColor: context.secondaryColor
                .withOpacity(0.5), // Cor de fundo azul claro
            filled: true, // Permite que o campo seja preenchido
            readOnly: true, // Adicionado para indicar que é somente leitura
            // decoration: InputDecoration(
            //   enabled: false, // Não permite interação
            //   border: InputBorder.none, // Remove a borda
            //   hintText: 'Rua, número, bairro', // Sugestão de formato
            // ),
          ),
          const SizedBox(height: 20),
          OrganizameElevatedButton(
            onPressed: () {},
            label: 'Adicionar Cliente',
            textColor: const Color(0xFFFAFFC5),
          ),
        ],
      ),
    );
  }
}
