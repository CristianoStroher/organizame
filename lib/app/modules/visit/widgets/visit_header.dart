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

  // Controladores para os campos de telefone e endereço
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Mapa para armazenar os dados de telefone e endereço dos clientes (exemplo)
  final Map<String, Map<String, String>> clientData = {
    'Cliente 1': {'telefone': '(11) 12345-6789', 'endereco': 'Rua A, 123'},
    'Cliente 2': {'telefone': '(21) 98765-4321', 'endereco': 'Rua B, 456'},
    'Cliente 3': {'telefone': '(31) 99999-8888', 'endereco': 'Rua C, 789'},
  };

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
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
          OrganizameDropdownfield(
            label: 'Cliente',
            clients: clients,
            selectedClient: selectedClient,
            onChanged: (newValue) {
              setState(() {
                selectedClient = newValue;

                // Atualiza os campos de telefone e endereço com base no cliente selecionado
                if (newValue != null && clientData.containsKey(newValue)) {
                  phoneController.text = clientData[newValue]!['telefone']!;
                  addressController.text = clientData[newValue]!['endereco']!;
                } else {
                  // Limpa os campos se nenhum cliente for selecionado
                  phoneController.clear();
                  addressController.clear();
                }
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
            controller: phoneController, // Usando o controlador
          ),
          const SizedBox(height: 10),
          OrganizameTextformfield(
            label: 'Endereço',
            controller: addressController, // Usando o controlador
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
